# NixOS Konfiguration für offnix Laptop
{ config, pkgs, lib, hostname, usernix, secondUsernix, useremail, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Hostname
  networking.hostName = hostname;
  networking.firewall.allowedTCPPorts = lib.mkAfter [ 3389 ];

  # Benutzer für offnix
  users.users = {
    ${usernix} = {
      isNormalUser = true;
      description = "Christian Eickhoff";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "scanner" "lp" ];
      shell = pkgs.zsh;
    };
    
    ${secondUsernix} = {
      isNormalUser = true;
      description = "Charlotte Amend";
      extraGroups = [ "networkmanager" "audio" "video" "scanner" "lp" ];
      shell = pkgs.zsh;
    };
  };


services.xserver = lib.mkForce {
  enable = true;
  xkb = {
    layout = "us";
    variant = "intl";
    options = "caps:escape";
  };
};
  # Laptop-spezifische Hardware-Unterstützung
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     
  #     # Battery charge thresholds (falls unterstützt)
  #     START_CHARGE_THRESH_BAT0 = 40;
  #     STOP_CHARGE_THRESH_BAT0 = 80;
  #     
  #     # CPU frequency scaling
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 30;
  #   };
  # };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  # Touchpad-Unterstützung
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = false;
      accelProfile = "adaptive";
    };
  };

  # Laptop-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Laptop-spezifische Tools
    acpi
    powertop
    brightnessctl
    lm_sensors
    
  ];

  # Hardware-spezifische Services
  services.thermald.enable = true;  # Intel thermal management
  # services.auto-cpufreq.enable = true;  # Automatische CPU-Frequenz-Anpassung

  # Backlight control
  # hardware.brightnessctl.enable = true;
  
  # Printing support
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip epson-escpr ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanner support
  hardware.sane.enable = true;
}
