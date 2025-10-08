# nix/secrets/secrets.nix
#
# Regeln für agenix: Welche öffentlichen Schlüssel (Recipients) dürfen die
# jeweiligen .age-Dateien entschlüsseln.
#
# Nutzung:
# - Am besten aus diesem Verzeichnis ausführen:
#     cd nix/secrets
#     agenix -e ssh/christian/id_ed25519.age
#   (agenix nimmt automatisch ./secrets.nix als RULES-Datei)
#
# - Alternativ aus dem Repo-Root:
#     RULES=nix/secrets/secrets.nix agenix -e nix/secrets/ssh/christian/id_ed25519.age
#
# Öffentliche Schlüssel eintragen:
# - User-Keys: z.B. Inhalt von ~/.ssh/id_ed25519.pub
# - Host-Keys: von Zielsystemen (NixOS-Hosts) mit: ssh-keyscan <hostname-or-ip>
#
# Wichtig:
# - Bitte die untenstehenden "REPLACE_WITH_..." Platzhalter durch echte
#   öffentliche SSH-Schlüssel ersetzen (Zeilen beginnen mit "ssh-ed25519 ..." oder "ssh-rsa ...").

let
  # ===========================
  # User Public Keys (Recipients)
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
  #   Tipp: ssh-keyscan offnix | grep ed25519
  # ===========================
  offnix_host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbIb9P4phSXKAksHgNwOmnSyMHSxRC3u7iA+BLARrZ+";
  devnix_host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPe/+rUbeMTV0Lne4mfGBXixGxbVkl8VqLmAhvf9k7W";
  # Optional: macOS host (falls verwendet)
  # macbookpro_host = "REPLACE_WITH_MACBOOKPRO_HOST_ED25519_KEY";

  systems = [
    offnix_host
    devnix_host
    # macbookpro_host
  ];

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
