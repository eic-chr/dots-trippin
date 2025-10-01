# NixOS Konfiguration für offnix Laptop
{
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
    ../shares.nix
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

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = true;
        FastConnectable = true;
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

  # Enable Flatpak with Flathub remote
  services.flatpak.enable = true;
  systemd.services.flatpak-add-flathub = {
    description = "Add Flathub Flatpak remote (system-wide)";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      if ! ${pkgs.flatpak}/bin/flatpak remotes --system | grep -q '^flathub'; then
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
      fi
    '';
  };

  # XDG desktop portals (unique selection to avoid duplicate user units)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Ensure XHC1 wake source is enabled (USB wake for BT keyboards)
  systemd.services.enable-xhc1-wakesource = {
    description = "Enable ACPI XHC1 wake source at boot";
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      if grep -q "^XHC1.*\*disabled" /proc/acpi/wakeup; then
        echo XHC1 > /proc/acpi/wakeup
      fi
    '';
  };

  powerManagement.resumeCommands = ''
    set -eu
    # Ensure BT USB stays powered and wake-capable after resume
    for p in /sys/bus/usb/drivers/btusb/*/power/control; do
      if [ -f "$p" ]; then
        echo on > "$p" || true
      fi
    done
    for p in /sys/bus/usb/drivers/btusb/*/power/wakeup; do
      if [ -f "$p" ]; then
        echo enabled > "$p" || true
      fi
    done
    # Power on Bluetooth and quickly try to auto-connect keyboards (non-blocking)
    rfkill unblock bluetooth || true
    ${pkgs.bluez}/bin/bluetoothctl --timeout 5 power on || true
    nohup sh -c '
      for i in $(seq 1 5); do
        ${pkgs.bluez}/bin/bluetoothctl --timeout 3 connect DB:8A:40:D8:0D:67 && break || true
        sleep 1
      done
      for i in $(seq 1 5); do
        ${pkgs.bluez}/bin/bluetoothctl --timeout 3 connect DF:74:62:BB:9B:2B && break || true
        sleep 1
      done
    ' >/dev/null 2>&1 &
  '';

  # Disable LID wake source (LID0) at boot to prevent unintended wakeups
  systemd.services.disable-lid-wakesource = {
    description = "Disable ACPI LID0 wake source";
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      if grep -q "^LID0.*\*enabled" /proc/acpi/wakeup; then
        echo LID0 > /proc/acpi/wakeup
      fi
    '';
  };

  # Clear RTC wakealarm before each suspend/hibernate to avoid scheduled wakeups
  systemd.services.clear-rtc-wakealarm = {
    description = "Clear RTC wakealarm before suspend/hibernate";
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    before = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      for rtc in /sys/class/rtc/rtc*/wakealarm; do
        echo 0 > "$rtc" || true
      done
    '';
  };

  # Ensure deep sleep is the default suspend mode
  boot.kernelParams = ["mem_sleep_default=s2idle"];

  # Disable Wake-on-LAN at boot (prevents unwanted wakeups)
  systemd.services.disable-wol = {
    description = "Disable Wake-on-LAN on all ethernet interfaces";
    wantedBy = ["multi-user.target"];
    after = ["network-pre.target"];
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
    wantedBy = ["multi-user.target"];
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
    wantedBy = ["multi-user.target"];
    after = ["bluetooth.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      set -eu
      for p in /sys/bus/usb/drivers/btusb/*/power/control; do
        if [ -f "$p" ]; then
          echo on > "$p" || true
        fi
      done
      for p in /sys/bus/usb/drivers/btusb/*/power/wakeup; do
        if [ -f "$p" ]; then
          echo enabled > "$p" || true
        fi
      done
    '';
  };
}
