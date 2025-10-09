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
  christian_personal =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9115pTLLpkhhZZh6qdlurEMHDZn7Gpv3yEfAxkNvhP christian@ewolutions.de";
  # Optional: zusätzliche User
  # charly_personal    = "REPLACE_WITH_CHARLY_PUBLIC_KEY";
  # vincent_personal   = "REPLACE_WITH_VINCENT_PUBLIC_KEY";
  # victoria_personal  = "REPLACE_WITH_VICTORIA_PUBLIC_KEY";

  users = [
    christian_personal
    # charly_personal
    # vincent_personal
    # victoria_personal
  ];

  # ===========================
  # Host Public Keys (Recipients)
  #   Tipp: ssh-keyscan -t ed25519 <hostname> | awk '{print $2" "$3}'
  # ===========================
  offnix_host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbIb9P4phSXKAksHgNwOmnSyMHSxRC3u7iA+BLARrZ+";
  devnix_host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPe/+rUbeMTV0Lne4mfGBXixGxbVkl8VqLmAhvf9k7W";
  # Optional: macOS host (falls verwendet)
  # macbookpro_host = "REPLACE_WITH_MACBOOKPRO_HOST_ED25519_KEY";

  # Per-user recipients: user's pubkey (if defined) + systems
  systemPubs = {
    offnix = offnix_host;
    devnix = devnix_host;
    # macbookpro = macbookpro_host;
  };

  # Gemeinsame Empfängerliste für Christians SSH-Keys:
  christian_recipients = users ++ systems;
in {
  # SSH Private Keys für christian
  #
  # Diese Dateinamen sind relativ zu diesem Verzeichnis (nix/secrets).
  # Sie passen zu deiner NixOS-Definition:
  # - common.nix legt die entschlüsselten Dateien nach /home/christian/.ssh/...
  # - flake.nix importiert agenix systemweit.

  "ssh/christian/id_ed25519.age".publicKeys = christian_recipients;

  "ssh/christian/info_ewolutions_de.age".publicKeys = christian_recipients;

  # Beispiel für weitere Secrets (auskommentiert):
  # "ssh/christian/another_key.age".publicKeys = christian_recipients;

  # Optional: Rausgeben in ARMOR/PEM-Format (lesbarere Diffs)
  # "ssh/christian/id_ed25519.age" = {
  #   publicKeys = christian_recipients;
  #   armor = true;
  # };
}
