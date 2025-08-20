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
    christian = {
      isNormalUser = true;
      description = "Christian Eickhoff";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "scanner" "lp" ];
      shell = pkgs.zsh;
    };
    
    charly = {
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
