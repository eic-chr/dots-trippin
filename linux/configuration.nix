# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "christian" ];
    };
    gc = {
      automatic = true;
      persistent = true;
      # options = "-d";
    };
  };


  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
      ./home-manager.nix
    ];


  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.wheelNeedsPassword = false;

# Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "devnix"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

# Set your time zone.
  time.timeZone = "Europe/Berlin";

# Select internationalisation properties.
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
# Enable the X11 windowing system.
  services.xserver = {
    enable = true;  
    layout = "us";
    xkbVariant = "intl";
    xkbOptions = "compose:dblquote";
    displayManager = {
      sessionCommands = ''
        ${pkgs.x11vnc}/bin/x11vnc -rfbauth $HOME/.vnc/passwd &
        '';
      autoLogin = {
        enable = false;
        user = "christian";
      };
# gdm = {
#   enable = false;  
#   wayland = true; 
# };
      sddm = {
        enable = true;
      };
    };
# desktopManager.gnome.enable = true; 
    desktopManager.plasma6.enable = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11"; #/run/current-system/sw/bin/gnome-session";
  };

  # Optionally, add a custom polkit rule
  environment.etc."polkit-1/rules.d/49-wheel.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

# Enable the GNOME Desktop Environment.
# services.xserver.desktopManager.xfce.enable = true;
# services.xrdp.enable = true;
# services.xrdp.defaultWindowManager = "gnome-remote-desktop";
# services.xrdp.extraConfDirCommands = "# some fun";
# services.xrdp.openFirewall = true;
# Configure keymap in X11

# Configure console keymap
  console.keyMap = "dvorak";

# Enable CUPS to print documents.
  services.printing.enable = true;

# Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christian = {
    isNormalUser = true;
    description = "Christian Eickhoff";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

# Install firefox.
  programs.firefox.enable = true;

  programs.zsh.enable = true;

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    fzf
      git-crypt
      ansible
      ripgrep
      jq
      polkit
      polkit-kde-agent
      pciutils
      clinfo
      gnumake
      gnupg
      htop
      lunarvim 
      nil
      partition-manager
      pavucontrol
      stow
      showmethekey
      simplescreenrecorder
      vscode
      x11vnc
      xclip
      vlc
      git
      tmux
# list2choice
# list-executables
# factorio
# jnv
# simple-formatter
# nix-deepclean
      ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Meslo" ]; })
      hack-font
      roboto
      dejavu_fonts
      noto-fonts-color-emoji
  ];


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-gtk2;
  };

# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

# Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3389 ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;
networking.extraHosts = ''
127.0.0.1 whoami.eickhoff-it.net       # Example
 
....

'';

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
