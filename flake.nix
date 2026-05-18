{
    description = "Flakes file. Sort of like third party packages for NixOS configuration";

    inputs = {
        # Requirement for everything. NOTE: Its possible to selectively use stable and unstable
	# for fine-grained control
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        # Allows configuration of applications and their config files using NixOS configuration
        home-manager.url = "github:nix-community/home-manager";
        # Can be combined into one scope with
        # Apparently important to make home-managers nixpkgs dependency to follow the systems nixpkgs version
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }: {
        # The 'desktop' hostname is just for building, this is not the network hostname
        nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            modules = [
                # My configuration
                ./configuration.nix

                # Use home-manager or something when building
                home-manager.nixosModules.home-manager

                # Here is the actual home-manager configuration
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

			    blender
                            bottles
                            discord
                            fastfetch
                            keepassxc
			    libreoffice
                            lmstudio
			    obsidian
			    openttd
			    proton-vpn-cli
			    vlc
			    yt-dlp
                        ];

                        xdg.configFile = {
                            "alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
                            "fish/config.fish".source = ./dotfiles/fish/config.fish;
                            "git/config".source = ./dotfiles/git/config;
                            "tmux/tmux.conf".source = ./dotfiles/tmux/tmux.conf;
                        };
                    };
                }
            ];
        };
    };
}
