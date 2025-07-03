{ config, pkgs, lib, ... }:

{
  networking.hostName = "devnix";

  # Import the common configuration
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];
  # English locale for devnix
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.christian = {
    isNormalUser = true;
    description = "Christian Eickhoff";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # RDP für Remote-Zugriff
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };

  # Firewall für RDP
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Enable docker for development
  virtualisation.docker.enable = true;

  # Development specific packages + KDE essentials
  environment.systemPackages = with pkgs; [
    # Development tools
    ansible
    clinfo
    docker
    golangci-lint
    gopls
    gofumpt
    gotools
    gomodifytags
    impl
    iferr
    gotests
    delve
    nil
    vscode
    zed-editor
    
    # KDE/Desktop essentials
    firefox
    kdePackages.konsole
    
    # Remote desktop tools
    remmina  # RDP client für Tests
  ];

  # Bootloader configuration specific to devnix
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "25.05";
}
