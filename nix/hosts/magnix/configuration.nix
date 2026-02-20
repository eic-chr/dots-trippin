{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../hyprland.nix # system Hyprland setup
    ../shares.nix
  ];

  services = {
    udisks2.enable = true;
    udev.extraRules = ''
      # Logitech Bolt Dongle Wakeup deaktivieren
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
    '';
  };
  services.teamviewer.enable = true;
  services.blueman.enable = true;
  programs.coolercontrol.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.systemPackages = with pkgs; [
    solaar
    liquidctl
    prismlauncher
    lutris
    heroic
    mangohud
    protonup-qt
    handbrake
    makemkv
    libdvdcss
  ];
}
