{

    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, home-manager, ... }:
        let
            commonModules = [
                ./configuration.nix
                ./home-manager.nix
            ];
        in
        {
            nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit home-manager; };
                modules = commonModules ++ [ ./hardware-desktop.nix ];
            };

            nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit home-manager; };
                modules = commonModules ++ [ ./hardware-laptop.nix ];
            };
        };

}
