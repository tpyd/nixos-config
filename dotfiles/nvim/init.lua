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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                transparent_mode = true,
                overrides = { Pmenu = { link = "Normal" } }  -- https://github.com/ellisonleao/gruvbox.nvim/issues/406
            })
            vim.cmd.colorscheme("gruvbox")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            vim.api.nvim_create_autocmd('FileType', { 
                callback = function() 
                    pcall(vim.treesitter.start) 
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" 
                end
            }) 

            -- local ensureInstalled = {
            --     "gitcommit",
            --     "lua",
            --     "markdown",
            --     "query",
            --     "rust",
            --     "toml"
            -- }
            -- local parsersToInstall = vim.iter(ensureInstalled):totable()
            -- require('nvim-treesitter').install(parsersToInstall)
        end
    },
    -- {
    --     "MeanderingProgrammer/treesitter-modules.nvim",
    --     opts = {
    --         ensure_installed = {
    --             "gitcommit",
    --             "lua",
    --             "markdown",
    --             "query",
    --             "rust",
    --             "toml"
    --         },
    --         auto_install = true,
    --         highlight = {
    --             enable = true
    --         },
    --         incremental_selection = {
    --             enable = true,
    --             keymaps = {
    --                 init_selection = "<Leader>ss",
    --                 node_incremental = "<Leader>si",
    --                 scope_incremental = "<Leader>sc",
    --                 node_decremental = "<Leader>sd"
    --             }
    --         },
    --         textobjects = {
    --             select = {
    --                 enable = true,
    --                 lookahead = true,
    --                 keymaps = {
    --                     ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
    --                     ["af"] = "@function.outer",
    --                     ["if"] = "@function.inner",
    --                     ["ac"] = "@class.outer",
    --                     ["ic"] = "@class.inner",
    --                 },
    --             }
    --         }
    --     }
    -- },
    -- {
    --     "nvim-treesitter/nvim-treesitter-textobjects"
    -- },
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                -- "lua_ls",
                -- "ruff",
                -- "rust_analyzer"
            }
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {}
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            local fzf = require("fzf-lua")

            vim.keymap.set("n", "<leader>pf", fzf.files)
            vim.keymap.set("n", "<leader>pg", fzf.live_grep)
            vim.keymap.set("n", "<leader>pb", fzf.buffers)
            vim.keymap.set("n", "<leader>pm", fzf.marks)
        end
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets"
        },
        opts = {
            fuzzy = {
                implementation = "lua"
            },
            -- sources = {
            --     default = {
            --         "lazydev",
            --         "lsp",
            --         "path",
            --         "snippets",
            --         "buffer"
            --     },
            --     providers = {
            --         lazydev = {
            --             name = "LazyDev",
            --             module = "lazydev.integrations.blink",
            --             score_offset = 100,
            --         }
            --     }
            -- },
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
        }
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function ()
            local harpoon = require("harpoon").setup({})
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
        end
    },
    -- {
    --     "folke/lazydev.nvim",
    --     ft = "lua",
    --     opts = {
    --         library = {
    --             {
    --                 path = "${3rd}/luv/library", words = { "vim%.uv" }
    --             }
    --         },
    --     },
    -- }
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(args)
--         local bufnr = args.buf
--         local opts = { noremap = true, buffer = bufnr }
--
--         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--         vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--         vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--         vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--         vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--         vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--         vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--         vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
--         vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
--         vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
--         vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
--     end
-- })

-- vim.lsp.config("lua_ls", {
--     on_init = function(client)
--         if client.workspace_folders then
--             local path = client.workspace_folders[1].name
--             if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path.."/.luarc.json") or vim.uv.fs_stat(path.."/.luarc.jsonc")) then
--                 return
--             end
--         end
--
--         client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
--             runtime = {
--                 version = "LuaJIT"
--             },
--             workspace = {
--                 checkThirdParty = false,
--                 library = {
--                     vim.env.VIMRUNTIME
--                 }
--             }
--         })
--     end,
--     settings = {
--         Lua = {}
--     }
-- })

-- vim.lsp.enable({
    -- "lua_ls",
    -- "ruff",
    -- "rust_analyzer"
-- })
