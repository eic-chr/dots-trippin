{ config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://cache.nixos.org/" ];
      trusted-substituters = [ "https://cache.nixos.org/" ];
      trusted-users = [ "root" "christian" ];
    };
    gc = {
      automatic = true;
      persistent = true;
    };
  };

  # Use doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.wheelNeedsPassword = false;

  # Set your time zone and locale
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

  # Enable Avahi for network discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # X11 configuration
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "intl";
    xkbOptions = lib.concatStringsSep "," [
      "altwin:swap_lalt_lwin"
      "ctrl:nocaps"
      "compose:dblquote"
      "caps:escape"
    ];
    exportConfiguration = true;
    displayManager = {
      sessionCommands = ''
        ${pkgs.x11vnc}/bin/x11vnc -rfbauth $HOME/.vnc/passwd &
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap us intl
      '';
      autoLogin = {
        enable = false;
        user = "christian";
      };
      sddm = {
        enable = true;
      };
    };
    desktopManager.plasma6.enable = true;
    # Configure input settings for all keyboards
    libinput = {
      enable = true;
    };
  };

  # Ensure keyboard settings persist
  environment.etc."X11/xorg.conf.d/00-keyboard.conf".text = ''
    Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us"
        Option "XkbVariant" "intl"
        Option "XkbOptions" "compose:ralt"
    EndSection
  '';

  # Remote desktop
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-wayland";
    openFirewall = true;
  };

  # Polkit rule for wheel group
  environment.etc."polkit-1/rules.d/49-wheel.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Printing
  services.printing.enable = true;

  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable common programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Common system packages
  environment.systemPackages = with pkgs; [
    direnv
    gcc
    gnumake
    pkg-config
    git
    git-crypt
    gnumake
    gnupg
    htop
    jq
    lunarvim
    kdePackages.partitionmanager
    pavucontrol
    pciutils
    polkit
    kdePackages.polkit-kde-agent-1
    ripgrep
    stow
    tmux
    vlc
    x11vnc
    xclip
    fzf
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.meslo-lg
    hack-font
    roboto
    dejavu_fonts
    noto-fonts-color-emoji
  ];

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 3389 ]; # RDP
  };

  # SSH
  services.openssh.enable = true;

  # Database support for KDE PIM/Akonadi
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {
        innodb_file_per_table = "ON";
        innodb_file_format = "Barracuda";
        innodb_large_prefix = "ON";
      };
    };
  };
}
