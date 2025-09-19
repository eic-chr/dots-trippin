# NixOS Konfiguration für offnix Laptop
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
  imports = [./hardware-configuration.nix ../common.nix];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["dotnet-runtime-7.0.20"];
  };
  # Hostname
  networking.hostName = hostname;

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

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {General = {Enable = "Source,Sink,Media,Socket";};};
  };
  services.blueman.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  programs.steam.enable = true;
  # Laptop-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Laptop-spezifische Tools
    acpi
    powertop
    brightnessctl
    lm_sensors
  ];

  # Hardware-spezifische Services
  services.thermald.enable = true; # Intel thermal management
  # services.auto-cpufreq.enable = true;  # Automatische CPU-Frequenz-Anpassung

  # Backlight control
  # hardware.brightnessctl.enable = true;

  # Printing support
  services.printing = {
    enable = true;
    drivers = with pkgs; [hplip epson-escpr];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanner support
  hardware.sane.enable = true;

  networking.firewall.enable = lib.mkForce false;
}
