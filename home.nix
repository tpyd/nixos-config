{
    home-manager.users.hades = { pkgs, ... }: {
        home.stateVersion = "26.05";
        nixpkgs.config.allowUnfree = true;

        home.packages = with pkgs; [ 
            alacritty
            fish
            git
            tmux
            nerd-fonts.ubuntu-mono

            # Neovim
            neovim
            gcc  # Required for compiling treesitter parsers
            fzf  # Required by file picker fzf-lua
            tree-sitter  # Needed for Neovim tree-sitter support after rewrite

            bottles
            discord
            fastfetch
            keepassxc
        ];

        xdg.configFile = {
            "alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
            "fish/config.fish".source = ./dotfiles/fish/config.fish;
            "git/config".source = ./dotfiles/git/config;
            "tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;
        };
    };
}
