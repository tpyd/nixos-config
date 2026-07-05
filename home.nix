{ self, config, pkgs, home-manager }: {

    imports = [
        home-manager.nixosModules.home-manager
    ];

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
            fd  # fzf-lua optional dependency
            ripgrep  # fzf-lua optional dependency

            blender
            btop
            discord
            fastfetch
            gimp
            jujutsu
            keepassxc
            libreoffice
            lmstudio
            obsidian
            openttd
            proton-vpn
            rustup
            signal-desktop
            vlc
            yt-dlp
        ];

        xdg.configFile = {
            "alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
            "fish/config.fish".source = ./dotfiles/fish/config.fish;
            "git/config".source = ./dotfiles/git/config;
            "jj/config.toml".source = ./dotfiles/jj/config.toml;
            "nvim/init.lua".source = ./dotfiles/nvim/init.lua;
            "nvim/nvim-pack-lock.json".source = ./dotfiles/nvim/nvim-pack-lock.json;
            "tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;
        };

        # Automatically start Proton VPN
        systemd.user.services."protonvpn-app" = {
            Unit = {
                Description = "Proton VPN";
            };
            Service = {
                ExecStart = "${pkgs.proton-vpn}/bin/protonvpn-app";
                Restart = "on-failure";
                RestartSec = "5s";
            };
            Install = {
                WantedBy = [ "graphical-session.target" ];
            };
        };
    };
}
