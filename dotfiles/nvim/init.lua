vim.env.LANG = "en_US"

vim.g.mapleader = " "

vim.diagnostic.config({
    virtual_text = true
})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 16
vim.opt.shiftwidth = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.virtualedit = "block"
vim.opt.winborder = "rounded"

vim.pack.add({
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp"
})

-- Set colorscheme
require("gruvbox").setup({
    transparent_mode = true,
    overrides = { Pmenu = { link = "Normal" } }  -- https://github.com/ellisonleao/gruvbox.nvim/issues/406
})
vim.cmd.colorscheme("gruvbox")

-- Set up fzf keymaps
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>pf", fzf.files)
vim.keymap.set("n", "<leader>pg", fzf.live_grep)
vim.keymap.set("n", "<leader>pb", fzf.buffers)
vim.keymap.set("n", "<leader>pm", fzf.marks)

-- Automatically install treesitter parser and enable it
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        local available_langs = require("nvim-treesitter").get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            local installed_langs = require("nvim-treesitter").get_installed()
            local installed = vim.tbl_contains(installed_langs, lang)
            if not installed then
                print("Installing parser for " .. lang)
                require("nvim-treesitter").install(lang):wait()
            end
            vim.treesitter.start()
            require("nvim-treesitter").indentexpr()
        end
    end
})

-- Set up textobjects
local textobjects = require("nvim-treesitter-textobjects.select")
vim.keymap.set({"x", "o"}, "af", function() textobjects.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({"x", "o"}, "if", function() textobjects.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({"x", "o"}, "ac", function() textobjects.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({"x", "o"}, "ic", function() textobjects.select_textobject("@class.inner", "textobjects") end)

-- Set up lualine
require("lualine").setup({})

-- Set up lazydev
require("lazydev").setup({})

-- Set up completion
local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup({
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            }
        }
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0
        },
        list = {
            selection = {
                auto_insert = false
            }
        }
    }
})

-- Set up LSPs
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer"
    }
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local opts = { noremap = true, buffer = bufnr }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    end
})

-- NOTE: The executables must be added to nix-ld if running NixOS
vim.lsp.enable({
    "lua_ls",
    "rust_analyzer"
})
