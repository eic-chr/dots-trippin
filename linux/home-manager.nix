{ lib, pkgs, ... }:
let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
user = builtins.getEnv "USER";
in
{
  imports = [
    (import "${home-manager}/nixos")
      ./users/${user}.nix
# ./git.nix
# ./plasma.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;



  fileSystems."/home/${user}/Scans" = {
    device = "//nas1.eickhoff.lan/Scans";
    fsType = "cifs";
    options = [ 
      "credentials=/home/${user}/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
  };
  fileSystems."/home/${user}/nas_multimedia" = {
    device = "//nas1.eickhoff.lan/Multimedia";
    fsType = "cifs";
    options = [ 
      "credentials=/home/${user}/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
  };
  fileSystems."/home/${user}/nas_home" = {
    device = "//nas1.eickhoff.lan/home";
    fsType = "cifs";
    options = [ 
      "credentials=/home/${user}/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
  };

  systemd.user.services.kbd-us-intl-service = {
    enable = true;
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    description = "Keyboard US International Airport Service";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''${pkgs.xorg.setxkbmap}/bin/setxkbmap us intl'';
      Environment = ''DISPLAY=:11.0'';
    };
  };
}
