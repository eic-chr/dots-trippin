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
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../hyprland.nix # system Hyprland setup
  ];

  # Hostname
  networking.hostName = hostname;
  networking.extraHosts = ''
    91.239.118.30 mail.ewolutions.de
  '';
  networking.firewall.allowedTCPPorts = lib.mkAfter [3389];

  # Dynamische Benutzer-Erstellung basierend auf hostUsers
  users.users = builtins.listToAttrs (map (user: {
      name = user;
      value = {
        isNormalUser = true;
        description = userConfigs.${user}.fullName or user;
        extraGroups =
          ["networkmanager" "audio" "video" "scanner" "lp" "input" "seat"]
          ++ lib.optionals (isAdmin user) ["wheel"]
          ++ lib.optionals (isDeveloper user) ["docker"];
        shell = pkgs.zsh;
      };
    })
    users);

  # Use Wayland/Hyprland session; disable X server to avoid conflicts.
  services.xserver.enable = lib.mkForce false;

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

  # Ensure deep sleep is the default suspend mode
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Disable Wake-on-LAN at boot (prevents unwanted wakeups)
  systemd.services.disable-wol = {
    description = "Disable Wake-on-LAN on all ethernet interfaces";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      for IFACE in /sys/class/net/*; do
        NAME="$(basename "$IFACE")"
        # Only touch physical interfaces
        if [ -e "$IFACE/device" ]; then
          ${pkgs.ethtool}/bin/ethtool -s "$NAME" wol d || true
        fi
      done
    '';
  };

  # Persistently disable PCIe Root Port wake sources (RP03/RP04/RP05)
  systemd.services.disable-acpi-wakeports = {
    description = "Disable ACPI wake sources (RP03/RP04/RP05)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      for DEV in RP03 RP04 RP05; do
        if grep -q "^$DEV.*\*enabled" /proc/acpi/wakeup; then
          echo "$DEV" > /proc/acpi/wakeup
        fi
      done
    '';
  };

  # Avoid Bluetooth autosuspend by forcing power/control=on for btusb devices
  systemd.services.bt-usb-power-on = {
    description = "Force Bluetooth USB devices power/control=on to avoid autosuspend";
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      for p in /sys/bus/usb/drivers/btusb/*/power/control; do
        if [ -f "$p" ]; then
          echo on > "$p" || true
        fi
      done
    '';
  };
}
