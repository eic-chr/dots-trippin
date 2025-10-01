{
  users,
  config,
  lib,
  ...
}: let
  # CIFS options common to most shares
  cifsCommonOptions = user: [
    "vers=3.0"
    "uid=${user}"
    "gid=users"
    "file_mode=0600"
    "dir_mode=0700"
    "nosuid"
    "nodev"
    "_netdev"
    "x-systemd.automount"
    "x-systemd.idle-timeout=600"
    "x-systemd.after=network-online.target"
    "x-systemd.requires=network-online.target"
  ];
  # CIFS shares definition (single source of truth)
  cifsShares = [
    rec {
      name = "Multimedia";
      what = "//nas1/Multimedia";
      target = user: "/home/${user}/nas_multimedia";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
    rec {
      name = "home";
      what = "//nas1/home";
      target = user: "/home/${user}/nas_home";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
    rec {
      name = "Scans";
      what = "//nas1/Scans";
      target = user: "/home/${user}/nas_scans";
      credentials = user: "/home/${user}/.smb_crd";
      options = user: (cifsCommonOptions user) ++ ["credentials=${credentials user}"];
    }
  ];
in {
  # Derive CIFS mounts from cifsShares for offnix/devnix
  fileSystems = lib.mkIf (builtins.elem config.networking.hostName ["offnix" "devnix"]) (
    builtins.listToAttrs (
      builtins.concatLists (map (
          share:
            map (user: {
              name = share.target user;
              value = {
                device = share.what;
                fsType = "cifs";
                options = share.options user;
              };
            })
            users
        )
        cifsShares)
    )
  );

  # Ensure mount points and secrets directory exist
  systemd.tmpfiles.rules = lib.optionals (builtins.elem config.networking.hostName ["offnix" "devnix"]) (
    ["d /etc/nixos/secrets 0700 root root -"]
    ++ builtins.concatLists (map (
        share:
          map (user: "d ${share.target user} 0700 ${user} ${user} -") users
      )
      cifsShares)
  );
}
