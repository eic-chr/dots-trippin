{ config, pkgs, lib, ... }:

{
  networking.hostName = "devnix";

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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Enable docker for development
  virtualisation.docker.enable = true;

  # Development specific packages
  environment.systemPackages = with pkgs; [
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
  ];

  # Bootloader configuration specific to devnix
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

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