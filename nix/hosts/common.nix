# Gemeensame NixOS Konfiguration für alle Hosts
{
  nur,
  pkgs,
  lib,
  users,
  userConfigs,
  hasPlasma,
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

  console.keyMap = "us";

  services.displayManager.sddm = {
    enable = true;
  };
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

  programs.zsh.enable = true;
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

  # System State Version
  system.stateVersion = "25.05";
}
