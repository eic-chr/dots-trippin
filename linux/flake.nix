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

      # Standalone Home-Manager configurations
      homeConfigurations = {
        "christian@devnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/users/christian.nix
            {
              home.username = "christian";
              home.homeDirectory = "/home/christian";
              home.stateVersion = "24.11";
              
              # Add host-specific packages for devnix
              home.packages = with pkgs; [
                docker
                vscode
                zed-editor
                golangci-lint
                gopls
                gofumpt
                gotools
                gomodifytags
                impl
                iferr
                gotests
                delve
              ];
            }
          ];
        };

        "christian@offnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/users/christian.nix
            {
              home.username = "christian";
              home.homeDirectory = "/home/christian";
              home.stateVersion = "24.11";
            }
          ];
        };

        "charlotte@offnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/users/charlotte.nix
            {
              home.username = "charlotte";
              home.homeDirectory = "/home/charlotte";
              home.stateVersion = "24.11";
            }
          ];
        };
      };
    };
}