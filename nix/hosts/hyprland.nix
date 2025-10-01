{
  pkgs,
  hyprlandInput,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  security.pam.services = {
    sddm.kwallet.enable = true;
    login.kwallet.enable = true;
  };

  environment.systemPackages = let
    # placeholder to align with external list; extend if needed
    python-packages = [];
  in
    (with pkgs; [
      polkit_gnome
      networkmanagerapplet
      libappindicator-gtk3
      libnotify
      qt6.qtwayland

      xdg-user-dirs
      xdg-utils

      brightnessctl
      playerctl
      grim
      slurp
      wl-clipboard
      swappy
      xfce.thunar
      wlogout
      jq
      nwg-dock-hyprland
      nwg-drawer
      pamixer
      pavucontrol
    ])
    ++ python-packages;
}
