
{
  pkgs,
  hyprlandInput,
  hyprlandPluginsPkgs,
  ...
}: {
  services.seatd.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  environment.sessionVariables.HYPRLAND_PLUGINS = "${hyprlandPluginsPkgs.hyprexpo}/lib/libhyprexpo.so";

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
    sddm.enableKwallet = true;
    login.enableKwallet = true;
  };

  environment.systemPackages = with pkgs; [
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    hyprsunset
    hyprpolkitagent
    rofi
    waybar
    samba
    cifs-utils
  ];
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
