# Simplified agenix RULES (explicit, no helper functions)
#
# This file declares each secret explicitly with its recipients.
# It avoids Nix functions so that agenix can eval to JSON reliably.
#
# Paths are relative to this file (secrets repo root).
#
# Conventions:
# - Place SSH private keys as encrypted .age files next to this rules file under:
#   ssh/<user>/shared/<basename>.age         # shared across all hosts
#   ssh/<user>/<hostname>/<basename>.age     # only for a specific host
#
# After changing recipients, run:  agenix --rekey

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
