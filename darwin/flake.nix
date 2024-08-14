{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # the @inputs allows custom packages from flakes for some reason
  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs
        {
          inherit system;
          config = { allowUnfree = true; };
        };
      username = "christianeickhoff";
    in
    {

      # for some reason the hostname seems to change sometimes
      # just use the same config twice
      darwinConfigurations = {
        "MBP-von-Christian" =
          darwin.lib.darwinSystem {
            inherit system pkgs;
            modules = [
              ./configuration.nix
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${username}" = import ./home.nix {
                  inherit username pkgs;
                };
              }
            ];
            specialArgs.username = username;
          };
        "MacBook-Pro-von-Christian" =
          darwin.lib.darwinSystem {
            inherit system pkgs;
            modules = [
              ./configuration.nix
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${username}" = import ./home.nix {
                  inherit username pkgs;
                };
              }
            ];
            specialArgs.username = username;
          };
      };
    };
}
