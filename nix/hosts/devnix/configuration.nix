# NixOS Konfiguration für devnix VM
{
  config,
  pkgs,
  lib,
  hostname,
  users,
  userConfigs,
  ...
}: let
  isAdmin = user: user == "christian" || userConfigs.${user}.isAdmin or false;
  isDeveloper = user: userConfigs.${user}.profile or null == "developer";
in {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../hyprland.nix # system Hyprland setup
  ];

  # Hostname
  networking.hostName = hostname;

  # Bootloader: use GRUB for BIOS (no EFI on this VM)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
  };

  # Dynamische Benutzer-Erstellung basierend auf hostUsers
  users.users = builtins.listToAttrs (map (user: {
      name = user;
      value = {
        isNormalUser = true;
        description = userConfigs.${user}.fullName or user;
        extraGroups =
          ["networkmanager" "audio" "video" "scanner" "lp"]
          ++ lib.optionals (isAdmin user) ["wheel"]
          ++ lib.optionals (isDeveloper user) ["docker"];
        shell = pkgs.zsh;
      };
    })
    users);

  # VM-spezifische Einstellungen
  services.qemuGuest.enable = true;

  # VM-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Development Tools für VM

    docker
    docker-compose

    # VM Tools
  ];

  # Docker für Development
  virtualisation.docker.enable = true;

  # VM-spezifische Services
  services.spice-vdagentd.enable = true; # Für bessere VM-Integration
}
