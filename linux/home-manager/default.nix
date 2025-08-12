{ config, pkgs, lib, ... }:

{
  imports = [ ./users ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Common configuration for all users
  home-manager.users = let
    commonConfig = {
      # Enable home-manager
      programs.home-manager.enable = true;

      # Common programs
      programs = {
        fzf.enable = true;
        direnv.enable = true;
        git.enable = true;
      };

      # State version
      home.stateVersion = "24.11";
    };
  in {
    christian = lib.mkMerge [
      commonConfig
      (import ./users/christian.nix { inherit config pkgs lib; })
    ];
  } // lib.optionalAttrs (config.networking.hostName == "offnix") {
    charlotte = lib.mkMerge [
      commonConfig
      (import ./users/charlotte.nix { inherit config pkgs lib; })
    ];
  };
}