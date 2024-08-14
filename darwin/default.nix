{ pkgs ? import <nixpkgs>, home-manager ? import <home-manager>, ... }:
let
  username = "christianeickhoff";
  system = "aarch64-darwinn";
  lombok-version = "1.18.28";
in {

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  imports = [ <home-manager/nix-darwin> ./configuration.nix ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${username}" =
    import ./home.nix { inherit username pkgs; };
}
