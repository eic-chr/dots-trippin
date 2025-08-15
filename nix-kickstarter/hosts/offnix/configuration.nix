# NixOS Konfiguration für offnix Laptop
{ config, pkgs, lib, hostname, usernix, secondUsernix, useremail, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Hostname
  networking.hostName = hostname;

  # Zusätzlicher Benutzer (ca)
  users.users.${secondUsernix} = {
    isNormalUser = true;
    description = "Second User";
    extraGroups = [ "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;
  };

  # Laptop-spezifische Hardware-Unterstützung
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Battery charge thresholds (falls unterstützt)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      
      # CPU frequency scaling
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;
    };
  };

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
      naturalScrolling = true;
      accelProfile = "adaptive";
    };
  };

  # Laptop-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Browser
    chromium
    
    # Office und Productivity
    thunderbird
    libreoffice
    
    # KDE Apps (zusätzlich zu denen in common.nix)
    kdePackages.kmail
    kdePackages.korganizer
    
    # Laptop-spezifische Tools
    acpi
    powertop
    brightnessctl
    lm_sensors
    
    # Multimedia
    vlc
    gimp
    inkscape
    
    # Development (falls gewünscht)
    vscode-fhs
  ];

  # Hardware-spezifische Services
  services.thermald.enable = true;  # Intel thermal management
  services.auto-cpufreq.enable = true;  # Automatische CPU-Frequenz-Anpassung

  # Backlight control
  hardware.brightnessctl.enable = true;
  
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
  users.users.${usernix}.extraGroups = [ "scanner" "lp" ];
  users.users.${secondUsernix}.extraGroups = [ "scanner" "lp" ];
}
