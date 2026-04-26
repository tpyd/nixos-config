{
    description = "Flakes file. Sort of like third party packages for NixOS configuration";

    inputs = {
        # Requirement for everything
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
                ./home.nix
            ];
        };
    };
}
