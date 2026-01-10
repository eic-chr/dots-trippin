# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
          [
            "dialout"
            "networkmanager"
            "audio"
            "video"
            "scanner"
            "lp"
            "input"
            "seat"
            "tun"
          ]
          ++ lib.optionals (isAdmin user) ["wheel"]
          ++ lib.optionals (isDeveloper user) ["docker"];
        shell = pkgs.zsh;
      };
    })
    users);

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = lib.mkForce false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.blueman.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  #  users.users.christian = {
  #    isNormalUser = true;
  #    description = "Christian Eickhoff";
  #    extraGroups = [ "networkmanager" "wheel" ];
  #    packages = with pkgs; [
  #      kdePackages.kate
  #    #  thunderbird
  #    ];
  #  };

  # Install firefox.
  #  programs.firefox.enable = true;
  programs.coolercontrol.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    #    neovim
    #    phoronix-test-suite
    solaar
    liquidctl
    prismlauncher
    lutris
    heroic
    mangohud
    protonup-qt
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
