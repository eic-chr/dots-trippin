
{ pkgs, ... }:
{
  home.username = "christian";
  home.homeDirectory = "/home/christian";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    signal-desktop
    stow

    ];
}
