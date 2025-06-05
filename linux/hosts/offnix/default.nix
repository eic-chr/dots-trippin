{ config, pkgs, lib, ... }:

{
  networking.hostName = "offnix";

  # User configurations
  users.users = {
    christian = {
      isNormalUser = true;
      description = "Christian Eickhoff";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
    charlotte = {
      isNormalUser = true;
      description = "Charlotte Amend";
      extraGroups = [ "networkmanager" ];
      shell = pkgs.zsh;
    };
  };

  # X11 keyboard configuration for Charlotte
  services.xserver.displayManager.sessionCommands = lib.mkIf (config.services.xserver.enable) ''
    if [ "$USER" = "charlotte" ]; then
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap de mac
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
      ${pkgs.xorg.xset}/bin/xset r rate 200 30
    fi
  '';

  # Office specific packages
  environment.systemPackages = with pkgs; [
    libreoffice
    joplin-desktop
    signal-desktop
    teamviewer
    # KDE PIM suite for Charlotte
    kdePackages.kmail
    kdePackages.kontact
    kdePackages.akonadi
    kdePackages.akonadi-mime
    kdePackages.akonadi-contacts
    kdePackages.akonadi-calendar
    kdePackages.kaddressbook
    kdePackages.korganizer
  ];

  # Enable TeamViewer service
  services.teamviewer.enable = true;

  # Akonadi runs as user service, configured in home-manager

  # Bootloader configuration specific to offnix
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Import the common configuration
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "24.11";
}
