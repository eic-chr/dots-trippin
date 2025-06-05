{ config, pkgs, lib, ... }:

{
  networking.hostName = "devnix";

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