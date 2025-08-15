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

  nixpkgs.config.allowUnfree = true;
# Use doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.wheelNeedsPassword = false;

# Set your time zone and locale
  time.timeZone = "Europe/Berlin";

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
    displayManager = {
      defaultSession = "plasmax11";
      sddm = {
        enable = true;
        wayland = {
          enable = false;
        };
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
# Wayland-Pakete explizit ausschließen
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-wayland-protocols
  ];


programs.nix-ld.enable = true;
# Enable common programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# Common system packages
  environment.systemPackages = with pkgs; [
      cargo
      fd
      fzf
      gcc
      git
      git-crypt
      gnumake
      gnumake
      gnupg
      htop
      imagemagick
      jq
      kdePackages.partitionmanager
      kdePackages.polkit-kde-agent-1
      kitty
      lazygit
      lua-language-server
      luaPackages.luarocks
      marksman
      markdownlint-cli
      mosh
      neovim
      nodejs
      pavucontrol
      pciutils
      pinentry-curses
      pkg-config
      polkit
      ripgrep
      stow
      tmux
      unzip
      vlc
      x11vnc
      xclip
      zk
      direnv
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

    firewall.allowedUDPPortRanges = [
      { from = 60000; to = 61000; }
    ];
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
