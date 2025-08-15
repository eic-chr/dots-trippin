# Gemeinsame NixOS Konfiguration für alle Hosts
{ config, pkgs, lib, usernix, useremail, ... }:

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
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    xkb = {
      layout = "us";
      variant = "intl";
    };
  };

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

  # Zsh global aktivieren
  programs.zsh.enable = true;

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
    vim
    nano
    wget
    curl
    git
    htop
    btop
    tree
    unzip
    zip
    file
    which
    
    # Netzwerk-Tools
    dig
    nmap
    traceroute
    
    # Development
    gcc
    gnumake
    pkg-config
    
    # KDE Apps (gemeinsam für alle KDE-Systeme)
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.okular
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.ark
    kdePackages.kcalc
    
    # Browser
    firefox
  ];
# Nix-Einstellungen
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" usernix ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
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
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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
