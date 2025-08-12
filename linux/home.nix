
{ config, pkgs, ... }:

let
  host = builtins.stringTrim (builtins.readFile "/etc/hostname");
  hostConfig = import ./hosts/${host}.nix { inherit pkgs; };
in

{
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";

  # Globale Pakete für alle Benutzer
  home.packages = with pkgs; [
    git
    htop
  ];

  # Host- und benutzerspezifische Einstellungen importieren
  imports = [ hostConfig ];
}
