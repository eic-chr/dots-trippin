# Gemeensame NixOS Konfiguration für alle Hosts
{
  config,
  agenix,
  nur,
  pkgs,
  lib,
  users,
  userConfigs,
  hasPlasma,
  hostname,
  secrets,
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
services.teamviewer.enable = true;
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
networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;
  security.sudo = {
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults env_keep += "SSH_AUTH_SOCK"
      '';
  };

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
      ntfs3g      # NTFS-Support (Lesen/Schreiben)
      dosfstools  # FAT/FAT32/ExFAT Tools (mkfs.vfat usw.)
      exfatprogs  # ExFAT Support
      screen
      minicom
      picocom    # minimalistisch
      tio        # modern & angenehm
      tmux

      git
      htop
      keepassxc
      libreoffice
      nextcloud-client

      lua-language-server
      gparted

      # Netzwerk-Tools
      dig

      traceroute

      # Development
      gcc
      gnumake
      just
      pkg-config
      markdownlint-cli2
      # Secrets tooling
      agenix.packages."${system}".default

      # Multimedia
      vlc
      gimp
      inkscape
      scribus


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
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["facetimehd-firmware" "code" "vscode" "vscode-fhs" "vscode-with-extensions" "visual-studio-code" "vscode-insiders" "vscode-extension-ms-vsliveshare-vsliveshare" "vscode-extension-ms-vscode-remote-remote-containers" "discord" "teamviewer" "broadcom-sta" "postman"];

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
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  system.stateVersion = "25.05";

  # agenix: deploy per-user SSH private keys when available
  # Scan nix/secrets/ssh/<user>/{shared,<hostname>} for *.age; host-specific overrides shared; copy into ~/.ssh (no symlinks)
  age.secrets = lib.mkMerge [
    (let
      mkUserEntries = user: let
        baseDir = "${secrets}/users/${user}";
        keyRegex = "id_.*_" + hostname + "\\.age";
        # collect .age files from shared and host-specific dirs
        readNames = dir: if builtins.pathExists dir then
          builtins.filter (n: let t = (builtins.readDir dir).${n} or null; in t == "regular" && builtins.match keyRegex n != null)
            (builtins.attrNames (builtins.readDir dir))
        else [];
        bases = readNames baseDir;
  # bases = builtins.filter
  #   (f: builtins.match keyRegex f != null)
  #   (builtins.attrNames (builtins.readDir baseDir));
        # build mappings baseName -> filePath (host overrides shared)
        mkOne = base: let
          baseName = builtins.replaceStrings [".age"] [""] base;
        in {
          name = "ssh-${user}-${baseName}";
          value = {
            file = "${baseDir}/${base}";
            owner = user;
            group = "users";
            mode = "600";
            path = "/home/${user}/.ssh/${baseName}";
            symlink = false;
          };
        };
      in map mkOne bases;
      entries = lib.concatLists (map mkUserEntries users);
    in
      builtins.listToAttrs entries)
    (let
      mkPwdEntry = user: let
        p = "${secrets}/users/${user}/passwd-${hostname}.age";
      in
        if builtins.pathExists p then [{
          name = "passwd-${user}";
          value = {
            file = p;
            owner = "root";
            group = "root";
            mode = "0400";
          };
        }] else [];
      entries = lib.concatLists (map mkPwdEntry users);
    in
      builtins.listToAttrs entries)
    (let
      # Generic per-user secrets with shared/host override
      # Place .age files under:
      #   users/<user>/secrets/shared/<name>.age           # shared across hosts
      #   users/<user>/secrets/<hostname>/<name>.age       # host-specific override
      #
      # Map desired secret names to their installation targets per user here.
      # Extend this attrset with more users and targets as needed.
      userSecretTargets = {
        christian = [
          {
            name = "github-token";
            path = "/home/christian/.config/gh/token";
            mode = "0400";
            symlink = false;
          }
          # {
          #   name = "aws-credentials";
          #   path = "/home/christian/.aws/credentials";
          #   mode = "0400";
          #   symlink = false;
          # }
        ];
        # vincent = [ ... ];
        # charly = [ ... ];
      };

      mkOneUser = user: let
        targets = userSecretTargets.${user} or [];
        mkOneTarget = t: let
          pHost = "${secrets}/users/${user}/secrets/${hostname}/${t.name}.age";
          pShared = "${secrets}/users/${user}/secrets/shared/${t.name}.age";
          src =
            if builtins.pathExists pHost then pHost
            else if builtins.pathExists pShared then pShared
            else null;
        in lib.optional (src != null) {
          name = "secret-${user}-${t.name}";
          value = {
            file = src;
            owner = user;
            group = "users";
            mode = t.mode or "0400";
            path = t.path;
            symlink = t.symlink or false;
          };
        };
      in lib.concatMap mkOneTarget targets;

      entries = lib.concatLists (map mkOneUser users);
    in
      builtins.listToAttrs entries
    )
  ];

  # Wire user hashed passwords from agenix secrets (initial-only via initialHashedPasswordFile). Existing users won't be changed on rebuild.
  # users.users = lib.mkMerge (map (u:
  #   lib.optionalAttrs (lib.hasAttr "passwd-${u}" config.age.secrets) {
  #     "${u}" = {
  #       initialHashedPasswordFile = config.age.secrets."passwd-${u}".path;
  #     };
  #   }
  # ) users);

  # ensure ~/.ssh exists with correct permissions for all users
  systemd.tmpfiles.rules = map (u: "d /home/${u}/.ssh 0700 ${u} users -") users;
}
