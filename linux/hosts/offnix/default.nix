{ config, pkgs, lib, ... }:

{
  networking.hostName = "offnix";

  # German locale for offnix
  i18n.defaultLocale = lib.mkForce "de_DE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

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

  # X11 keyboard configuration - German layout for offnix
  services.xserver = {
    layout = lib.mkForce "de";
    xkbVariant = lib.mkForce "";
    xkbOptions = lib.mkForce (lib.concatStringsSep "," [
      "compose:ralt"
      "caps:escape"
    ]);
  };

  # Override keyboard configuration from common.nix for German layout
  environment.etc."X11/xorg.conf.d/00-keyboard.conf" = lib.mkForce {
    text = ''
      Section "InputClass"
          Identifier "system-keyboard"
          MatchIsKeyboard "on"
          Option "XkbLayout" "de"
          Option "XkbVariant" "mac"
          Option "XkbOptions" "compose:ralt"
      EndSection
    '';
  };

  # Additional session commands for Charlotte's MacBook keyboard
  services.xserver.displayManager.sessionCommands = lib.mkIf (config.services.xserver.enable) ''
    if [ "$USER" = "charlotte" ]; then
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap de mac
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
      ${pkgs.xorg.xset}/bin/xset r rate 200 30
    else
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap de
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt
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
