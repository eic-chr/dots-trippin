{ config, pkgs, lib, ... }:
{
  networking.hostName = "devnix";
  
  # Import the common configuration
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];
  
  # English locale for devnix
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  users.users.christian = {
    isNormalUser = true;
    description = "Christian Eickhoff";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };
  
  # Display-Konfiguration für X11 erzwingen
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;  # Explizit Wayland deaktivieren
  };
  services.desktopManager.plasma6.enable = true;
  
  # X11 als Default-Session erzwingen
  services.displayManager.defaultSession = "plasmax11";
  
  # Umgebungsvariablen für X11 erzwingen
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
    GDK_BACKEND = "x11";
    WAYLAND_DISPLAY = "";
    NIXOS_OZONE_WL = "0";
    MOZ_ENABLE_WAYLAND = "0";
  };
  
  # RDP für Remote-Zugriff
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;  # Automatisch Firewall öffnen
  };
  
  # SSH für Remote-Zugriff
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  
  # Firewall für RDP und SSH
  networking.firewall.allowedTCPPorts = [ 22 3389 ];
  
  # Enable docker for development
  virtualisation.docker.enable = true;
  
  # Development specific packages + KDE essentials
  environment.systemPackages = with pkgs; [
    # Development tools
    ansible
    clinfo
    docker
    golangci-lint
    gopls
    gofumpt
    gotools
    gomodifytags
    impl
    iferr
    gotests
    delve
    nil
    vscode
    zed-editor
    
    # KDE/Desktop essentials
    firefox
    kdePackages.konsole
    kdePackages.kate
    
    # Remote desktop tools
    remmina  # RDP client für Tests
    tigervnc
    freerdp
    x11vnc
  ];
  
  # Bootloader configuration specific to devnix
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "25.05";
}
