# nix/secrets/secrets.nix
#
# Dynamische agenix-RULES:
# - Scannt ssh/<user>/ nach *.age
# - Weist pro User-Ordner Recipients (user's pubkey ++ hosts) zu
#
# Nutzung:
#   cd nix/secrets
#   agenix -e ssh/<user>/<dateiname>.age
#
# Hinweise:
# - Trage unten eure User-/Host-Public-Keys ein.
# - Alle gefundenen Dateien unter ssh/<user>/*.age bekommen automatisch die Default-Recipients.

let
  # ===========================
  # User Public Keys (per user)
  # ===========================
  userPubs = {
    christian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9115pTLLpkhhZZh6qdlurEMHDZn7Gpv3yEfAxkNvhP christian@ewolutions.de";
  };

  # ===========================
  # Host Public Keys (Recipients)
  #   Tipp: ssh-keyscan -t ed25519 <hostname> | awk '{print $2" "$3}'
  # ===========================
  offnix_host  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbIb9P4phSXKAksHgNwOmnSyMHSxRC3u7iA+BLARrZ+ root@offnix";
  devnix_host  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPe/+rUbeMTV0Lne4mfGBXixGxbVkl8VqLmAhvf9k7W root@nixos";
  # macbookpro_host = "ssh-ed25519 AAAA... root@MacBookPro";

  # Per-user recipients: user's pubkey (if defined) + systems
  systemPubs = {
    offnix = offnix_host;
    devnix = devnix_host;
    # macbookpro = macbookpro_host;
  };

  allSystemPublicKeys = builtins.attrValues systemPubs;

  recipientsForShared = user:
    let userPubKey = userPubs.${user} or null;
    in (if userPubKey != null then [ userPubKey ] else []) ++ allSystemPublicKeys;

  recipientsForHost = user: host:
    let
      userPubKey = userPubs.${user} or null;
      hostPublicKey = systemPubs.${host} or null;
    in
      if hostPublicKey == null then []
      else (if userPubKey != null then [ userPubKey ] else []) ++ [ hostPublicKey ];

  # ===========================
  # Dynamische Erzeugung der Regeln aus ssh/<user>/{shared,<host>}/*.age
  # ===========================
  sshRoot = ./ssh;
  sshDirectoryEntries = builtins.readDir sshRoot;
  userDirectoryNames = builtins.filter (entryName: (sshDirectoryEntries.${entryName} or null) == "directory") (builtins.attrNames sshDirectoryEntries);

  filesIn = directoryPath: let
    dirEntries = if builtins.pathExists directoryPath then builtins.readDir directoryPath else {};
  in
    builtins.filter (fileName: (builtins.hasAttr fileName dirEntries) && dirEntries.${fileName} == "regular" && builtins.match ".*\\.age$" fileName != null) (builtins.attrNames dirEntries);

  hostDirsFor = user: let
    userDirEntries = if builtins.pathExists "${sshRoot}/${user}" then builtins.readDir "${sshRoot}/${user}" else {};
  in
    builtins.filter (entryName: (userDirEntries.${entryName} or null) == "directory" && entryName != "shared") (builtins.attrNames userDirEntries);

  sharedEntriesFor = user: let
    sharedDirPath = "${sshRoot}/${user}/shared";
  in
    builtins.map (fileName: {
      name = "ssh/${user}/shared/${fileName}";
      value = { publicKeys = recipientsForShared user; };
    }) (filesIn sharedDirPath);

  hostEntriesFor = user:
    builtins.concatMap (host:
      let hostPublicKey = systemPubs.${host} or null; in
      if hostPublicKey == null then []
      else builtins.map (fileName: {
        name = "ssh/${user}/${host}/${fileName}";
        value = { publicKeys = recipientsForHost user host; };
      }) (filesIn "${sshRoot}/${user}/${host}")
    ) (hostDirsFor user);

  entries =
    builtins.concatMap (userName: (sharedEntriesFor userName) ++ (hostEntriesFor userName)) userDirectoryNames;
in
builtins.listToAttrs entries
