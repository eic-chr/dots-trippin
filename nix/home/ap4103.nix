# Home-Manager Konfiguration MacBook
{ config, lib, pkgs, unstable, currentUser, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/projects/ceickhoff/dots";
  stowPackages = [ "nvim" ];
in {
  # Importiere deine bestehenden Module
  imports = [
    ./core.nix
    ./git.nix
    ./opencode.nix
    ./shell.nix
    ./starship.nix
    ./kitty.nix
    ./vscode.nix
  ];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home = {
    username = currentUser;
    homeDirectory = "/Users/${currentUser}";
    stateVersion = "25.11";
    activation.stowDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cd ${dotfilesDir}
      ${pkgs.stow}/bin/stow -R -t ${config.home.homeDirectory} ${
        lib.concatStringsSep " " stowPackages
      }
    '';

    # Zusätzliche NixOS-spezifische Pakete
    packages = [ ];
  };

  services = { ssh-agent.enable = true; };
}
