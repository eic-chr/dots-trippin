{
  pkgs,
  hyprlandInput,
  splitMonitorWorkspaces,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland;
    # package =
    #  (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland.override {
    #    plugins = [
    #      splitMonitorWorkspaces.packages.${pkgs.system}.split-monitor-workspaces
    #    ];
     # };
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
      # Hyprland session essentials kept system-wide (others via Home Manager)
      polkit_gnome
      networkmanagerapplet
      libappindicator-gtk3
      libnotify
      qt6.qtwayland

      # XDG helpers
      xdg-user-dirs
      xdg-utils

      # Hyprland user tools (previously in HM hyprland.nix)
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
    ]) ++ python-packages;

  # KWallet is started on-demand via D-Bus (see services.dbus.packages = [ pkgs.kdePackages.kwallet ];)
  # Create mount points for CIFS templates
  systemd.tmpfiles.rules = [
    "d /mnt/share-guest 0755 root root -"
    "d /mnt/share-auth 0700 root root -"
  ];

  # CIFS guest mount template (adjust SERVER/SHARE and remove noauto when ready)
  fileSystems."/mnt/share-guest" = {
    device = "//SERVER/SHARE";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "vers=3.1.1"
      "uid=1000"
      "gid=1000"
      "file_mode=0644"
      "dir_mode=0755"
      "nofail"
      "guest"
      "noserverino"
    ];
  };

  # CIFS credential-based mount template
  # Place credentials at /etc/nixos/secrets/smb-auth.cred with:
  #   username=MYUSER
  #   password=MYPASS
  #   domain=MYDOMAIN   # optional
  fileSystems."/mnt/share-auth" = {
    device = "//SERVER/PRIVATE";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "vers=3.1.1"
      "uid=1000"
      "gid=1000"
      "file_mode=0640"
      "dir_mode=0750"
      "nofail"
      "credentials=/etc/nixos/secrets/smb-auth.cred"
      "noserverino"
    ];
  };
}
