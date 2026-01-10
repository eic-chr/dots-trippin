# NixOS Konfiguration für offnix Laptop
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../hyprland.nix # system Hyprland setup
    ../shares.nix
  ];
  nixpkgs.config.allowInsecurePredicate = pkg:
    builtins.elem (lib.getName pkg) ["broadcom-sta"];

  hardware.facetimehd.enable = true;

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

  # Laptop-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Laptop-spezifische Tools
    acpi
    powertop
    brightnessctl
    lm_sensors
  ];

  # Hardware-spezifische Services
  services = {
    blueman.enable = true;

    # Touchpad-Unterstützung
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = false;
        accelProfile = "adaptive";
      };
    };
    thermald.enable = true; # Intel thermal management

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    # udev-Regeln für MacBook-spezifische Hardware
    udev.extraRules = ''
      # MacBook Tastatur-Hintergrundbeleuchtung
      SUBSYSTEM=="leds", KERNEL=="smc::kbd_backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"

      # MacBook Bildschirm-Helligkeit
      SUBSYSTEM=="backlight", KERNEL=="intel_backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    '';
  };

  # Ensure XHC1 wake source is enabled (USB wake for BT keyboards)
  systemd = {
    # Disable LID wake source (LID0) at boot to prevent unintended wakeups
    services = {
      # Disable Wake-on-LAN at boot (prevents unwanted wakeups)
      disable-wol = {
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
      disable-acpi-wakeports = {
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
      bt-usb-power-on = {
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

      disable-lid-wakesource = {
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
      clear-rtc-wakealarm = {
        description = "Clear RTC wakealarm before suspend/hibernate";
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        before = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        serviceConfig.Type = "oneshot";
        script = ''
          set -eu
          for rtc in /sys/class/rtc/rtc*/wakealarm; do
            echo 0 > "$rtc" || true
          done
        '';
      };
      enable-xhc1-wakesource = {
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
    };
  };

  powerManagement = {
    powerDownCommands = ''
      set -eu
      # Save and turn off keyboard backlight before suspend/hibernate
      KB_DIR="/sys/class/leds/smc::kbd_backlight"
      if [ ! -d "$KB_DIR" ]; then
        for d in /sys/class/leds/*kbd_backlight*; do
          if [ -d "$d" ]; then KB_DIR="$d"; break; fi
        done
      fi
      if [ -d "$KB_DIR" ]; then
        if [ -r "$KB_DIR/brightness" ]; then
          cat "$KB_DIR/brightness" > /run/kbd_backlight.prev || true
          chmod 600 /run/kbd_backlight.prev || true
          echo "$KB_DIR" > /run/kbd_backlight.path || true
          chmod 600 /run/kbd_backlight.path || true
          echo 0 > "$KB_DIR/brightness" || true
        fi
      fi
    '';

    resumeCommands = ''
      set -eu
      # Restore keyboard backlight level saved before suspend
      if [ -f /run/kbd_backlight.path ] && [ -f /run/kbd_backlight.prev ]; then
        KB_DIR="$(cat /run/kbd_backlight.path)"
        if [ -w "$KB_DIR/brightness" ]; then
          PREV="$(cat /run/kbd_backlight.prev)"
          echo "$PREV" > "$KB_DIR/brightness" || true
        fi
        rm -f /run/kbd_backlight.prev /run/kbd_backlight.path || true
      fi

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
  };
}
