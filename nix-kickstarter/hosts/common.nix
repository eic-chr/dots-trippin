# Gemeinsame NixOS Konfiguration für alle Hosts
{ config, pkgs, lib, usernix, useremail, hasPlasma, ... }:

{
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
  # Display Manager - Neue separate Konfiguration
  services.displayManager.sddm = {
    enable = true;
    # Für MacBook Pro 2014: X11 ist stabiler
    wayland.enable = false;
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
  environment.systemPackages = with pkgs; [
    # Systemtools
    btop
    cifs-utils
    curl
    file
    git
    htop
    keepassxc
    libreoffice
    nano
    nextcloud-client
    python3
    thunderbird
    tree
    unzip
    wget
    which
    zip
    
    # Netzwerk-Tools
    dig
    nmap
    traceroute
    
    # Development
    gcc
    gnumake
    just
    pkg-config

    xclip
        # Multimedia
    vlc
    gimp
    inkscape
    
    # Development (falls gewünscht)
    vscode-fhs
    
    # Browser
    firefox
    chromium

    # KDE Apps (gemeinsam für alle KDE-Systeme)
  ] ++ lib.optionals hasPlasma [
    # KDE-spezifische Pakete
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-extras
    kdePackages.kmail
    kdePackages.kolourpaint
    kdePackages.konsole
    kdePackages.korganizer
    kdePackages.merkuro
    kdePackages.okular
    kdePackages.qtimageformats
    kdePackages.spectacle
    
  ];
# Nix-Einstellungen
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" usernix ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Font-Konfiguration
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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
