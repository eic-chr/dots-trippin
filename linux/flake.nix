{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        devnix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/devnix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.christian = import ./home-manager/users/christian.nix;
            }
          ];
        };

        offnix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/offnix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users = {
                christian = import ./home-manager/users/christian.nix;
                charlotte = import ./home-manager/users/charlotte.nix;
              };
            }
          ];
        };
      };
    };
}