# Gemeensame NixOS Konfiguration für alle Hosts
{
  config,
  nur,
  pkgs,
  lib,
  users,
  userConfigs,
  hasPlasma,
  hostname,
  unstable,
  ...
}: let
  # Nur Developer und Admin-Profile bekommen Nix-Vertrauen
  trustedProfiles = ["developer" "admin"];
  trustedUsers =
    builtins.filter (
      user:
        builtins.elem (userConfigs.${user}.profile or "none") trustedProfiles
    )
    users;

  # CIFS options common to most shares
  cifsCommonOptions = user: [
    "vers=3.0"
    "uid=${user}"
    "gid=users"
    "file_mode=0600"
    "dir_mode=0700"
    "nosuid"
    "nodev"
    "_netdev"
    "x-systemd.automount"
    "x-systemd.idle-timeout=600"
    "x-systemd.after=network-online.target"
    "x-systemd.requires=network-online.target"
  ];
  # CIFS shares definition (single source of truth)
  cifsShares = [
    rec {
      name = "Multimedia";
      what = "//nas1/Multimedia";
      target = user: "/home/${user}/nas_multimedia";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
    rec {
      name = "home";
      what = "//nas1/home";
      target = user: "/home/${user}/nas_home";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
    rec {
      name = "Scans";
      what = "//nas1/Scans";
      target = user: "/home/${user}/nas_scans";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
  ];
in {
  # Zeitzone und Lokalisierung
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Console Keymap
  console.keyMap = "us";

  # X11 und Desktop Environment (KDE Plasma)
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "intl";
    };
  };

  # Display Manager - Neue separate Konfiguration
  services.displayManager.sddm = {
    enable = true;
    # Für MacBook Pro 2014: X11 ist stabiler
  };
  # Desktop Manager - Neue separate Konfiguration
  services.desktopManager.plasma6.enable = true;

  # XDG Portal für KDE
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  boot.extraModulePackages = [pkgs.linuxPackages.broadcom_sta];
  boot.blacklistedKernelModules = [
    "b43"
    "bcma"
    "brcmsmac"
    "ssb"
    "brcmfmac"
  ];
  boot.supportedFilesystems = ["cifs"];
  # RDP Server für Remote Desktop (funktioniert mit Wayland)

  # Netzwerk
  networking.networkmanager.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Benutzer werden in host-spezifischen Configs definiert
  # (entfernt um Konflikte zu vermeiden)

  programs.zsh.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Sudo ohne Passwort für wheel-Gruppe
  security.sudo.wheelNeedsPassword = false;

  # Enable KWallet unlock via PAM for SDDM and TTY login
  security.pam.services = {
    sddm.kwallet.enable = true;
    login.kwallet.enable = true;
  };

  # Provide D-Bus service for kwalletd6 (Plasma 6)
  services.dbus.packages = [pkgs.kdePackages.kwallet];

  # Ensure plasma-kwallet-pam starts at login
  systemd.user.services.plasma-kwallet-pam-ensure = {
    description = "Ensure plasma-kwallet-pam.service is started at login";
    after = ["graphical-session.target" "dbus.service"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user start plasma-kwallet-pam.service";
      RemainAfterExit = true;
    };
  };

  # Sanity-check Secret Service availability at user login (more robust)
  systemd.user.services.secret-service-sanity = {
    description = "Sanity-check Secret Service (org.freedesktop.secrets) availability at login";
    wants = ["plasma-kwallet-pam.service"];
    after = ["plasma-kwallet-pam.service" "dbus.service"];
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -lc '\
                   for i in {1..10}; do \
                     if busctl --user list | grep -q org.freedesktop.secrets; then \
                       echo \"[OK] Secret Service available\"; exit 0; \
                         fi; \
                         sleep 0.5; \
                         done; \
                         echo \"[WARN] Secret Service missing after wait, trying to start plasma-kwallet-pam\"; \
                         ${pkgs.systemd}/bin/systemctl --user start plasma-kwallet-pam.service || true; \
                         sleep 1; \
                         if busctl --user list | grep -q org.freedesktop.secrets; then \
                           echo \"[OK] Secret Service available after start\"; exit 0; \
                         else \
                           echo \"[ERROR] Secret Service unavailable\"; exit 1; \
                             fi'";
    };
  };

  # Audio mit PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # KDE-spezifische System-Pakete
  environment.systemPackages = with pkgs;
    [
      # Systemtools
      btop
      cifs-utils
      curl

      git
      htop
      keepassxc
      libreoffice
      nextcloud-client

      lua-language-server

      # Netzwerk-Tools
      dig

      traceroute

      # Development
      gcc
      gnumake
      just
      pkg-config
      markdownlint-cli2

      # Multimedia
      vlc
      gimp
      inkscape

      # Browser

      # KDE Apps (gemeinsam für alle KDE-Systeme)
    ]
    ++ lib.optionals hasPlasma [
      # KDE-spezifische Pakete
      kdePackages.ark
      kdePackages.dolphin
      kdePackages.gwenview
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.kdegraphics-thumbnailers
      kdePackages.krfb
      kdePackages.kio-extras
      kdePackages.kmail
      kdePackages.kolourpaint
      kdePackages.konsole
      kdePackages.korganizer
      kdePackages.ksystemlog
      kdePackages.merkuro
      kdePackages.okular
      kdePackages.qtimageformats
      kdePackages.spectacle
    ];
  # Nix-Einstellungen
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root"] ++ trustedUsers;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };
  # Nixpkgs-Konfiguration mit NUR
  nixpkgs.overlays = [
    nur.overlays.default
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["code" "vscode" "vscode-fhs" "vscode-with-extensions" "visual-studio-code" "vscode-insiders" "vscode-extension-ms-vsliveshare-vsliveshare" "vscode-extension-ms-vscode-remote-remote-containers" "discord" "teamviewer" "broadcom-sta" "postman"];

  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) ["broadcom-sta"];
  # Firewall
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [22]; # SSH
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # # Mountpoints erstellen und Rechte setzen
  # system.activationScripts.mkMountDirs.text = ''
  #   ${lib.concatStringsSep "\n" (map (user: ''
  #       mkdir -p /mnt/nas_homes/${user}
  #       chown ${user}:${user} /mnt/nas_homes/${user}
  #     '')
  #     users)}
  # '';

  services.gvfs.enable = true;
  # Font-Konfiguration
  fonts = {
    packages = with pkgs; [
      font-awesome
      material-design-icons
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "slight";
    };
  };

  # CIFS mount for nas_home moved to hosts/offnix/configuration.nix

  # systemd.tmpfiles.rules for nas_home moved to hosts/offnix/configuration.nix

  # Autofs configuration removed

  # Removed autofs map file

  # Removed nas_home tmpfiles rule from common

  # Removed activation script cleanup for nas_home units

  # Derive CIFS mounts from cifsShares for offnix/devnix
  fileSystems = lib.mkIf (builtins.elem config.networking.hostName ["offnix" "devnix"]) (
    builtins.listToAttrs (
      builtins.concatLists (map (
          share:
            map (user: {
              name = share.target user;
              value = {
                device = share.what;
                fsType = "cifs";
                options = share.options user;
              };
            })
            users
        )
        cifsShares)
    )
  );

  # Ensure mount points and secrets directory exist
  systemd.tmpfiles.rules = lib.optionals (builtins.elem config.networking.hostName ["offnix" "devnix"]) (
    ["d /etc/nixos/secrets 0700 root root -"]
    ++ builtins.concatLists (map (
        share:
          map (user: "d ${share.target user} 0700 ${user} ${user} -") users
      )
      cifsShares)
  );

  # System State Version
  system.stateVersion = "25.05";
}
