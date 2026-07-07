{ home-manager, ... }: {

    imports = [
        home-manager.nixosModules.home-manager
    ];

    home-manager.users.hades = { pkgs, ... }: {
        home.stateVersion = "25.11";
        nixpkgs.config.allowUnfree = true;

        home.packages = with pkgs; [ 
            # Development
            alacritty
            btop
            fastfetch
            fd
            fzf
            gcc
            git
            jujutsu
            neovim
            nerd-fonts.ubuntu-mono
            ripgrep
            rustup
            tmux
            tree-sitter

            # Tools
            kdePackages.bluedevil
            kdePackages.kcalc
            keepassxc
            proton-vpn
            yt-dlp

            # Productivity
            blender
            gimp
            libreoffice
            lmstudio
            obs-studio
            obsidian
            vlc

            # Messaging
            discord
            signal-desktop

            # Games
            openttd
        ];

        # Dotfiles
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
