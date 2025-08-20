{
  description = "Nix-Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-darwin, darwin, home-manager, plasma-manager, ... }:
      let
      inherit (inputs.nixpkgs) lib;
      mylib = import ../lib { inherit lib; };
      myvars = import ../vars { inherit lib; };
          specialArgs =
      inputs
      // {
        inherit mylib myvars;
      };
    in
  {
    # === NixOS Systeme ===
    nixosConfigurations = {
      
      # Development VM - nur christian
      devnix = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/devnix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.christian = import ./home/christian.nix;
          }
        ];
      };
      
      # Office Laptop - christian + charly
      offnix = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/offnix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.christian = import ./home/christian/offnix.nix;
            home-manager.users.charly = import ./home/charly.nix;
          }
        ];
      };
      
      # Gaming Laptop - christian + vincent + victoria
      playnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/playnix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.christian = import ./home/christian.nix;
            home-manager.users.vincent = import ./home/vincent.nix;
            home-manager.users.victoria = import ./home/victoria.nix;
          }
        ];
      };
    };

    # === macOS System ===
    darwinConfigurations = {
      MacBookPro = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/MacBookPro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.christianeickhoff = import ./home/christian-mac.nix;
          }
        ];
      };
    };

    # === Formatter ===
    formatter = {
      x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      aarch64-darwin = nixpkgs-darwin.legacyPackages.aarch64-darwin.alejandra;
    };
  };
}
