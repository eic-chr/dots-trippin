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
  # User public keys
  christian_pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9115pTLLpkhhZZh6qdlurEMHDZn7Gpv3yEfAxkNvhP christian@ewolutions.de";
  # charly_pub   = "ssh-ed25519 AAAA... charly@host";
  # vincent_pub  = "ssh-ed25519 AAAA... vincent@host";
  # victoria_pub = "ssh-ed25519 AAAA... victoria@host";

  # Host (system) public keys
  offnix_host_pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbIb9P4phSXKAksHgNwOmnSyMHSxRC3u7iA+BLARrZ+ root@offnix";
  devnix_host_pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPe/+rUbeMTV0Lne4mfGBXixGxbVkl8VqLmAhvf9k7W root@nixos";
  # playnix_host_pub   = "ssh-ed25519 AAAA... root@playnix";
  # macbookpro_host_pub= "ssh-ed25519 AAAA... root@MacBookPro";
in
{
  # ==========================================
  # christian's SSH secrets
  # ==========================================

  # Shared across all hosts
  "ssh/christian/shared/info_ewolutions_de.age".publicKeys = [
    christian_pub
    offnix_host_pub
    devnix_host_pub
    # playnix_host_pub
    # macbookpro_host_pub
  ];

  # Host-specific
  "ssh/christian/offnix/id_ed25519.age".publicKeys = [
    christian_pub
    offnix_host_pub
  ];

  "ssh/christian/devnix/id_ed25519.age".publicKeys  = [
    christian_pub
    devnix_host_pub
  ];

  # ==========================================
  # Examples for additional users/hosts
  # ==========================================
  # "ssh/vincent/shared/github.age".publicKeys = [
  #   vincent_pub
  #   offnix_host_pub
  #   devnix_host_pub
  #   # playnix_host_pub
  # ];
  #
  # "ssh/vincent/offnix/id_ed25519_offnix.age".publicKeys = [
  #   vincent_pub
  #   offnix_host_pub
  # ];

  # ==========================================
  # Optional: Output in PEM armor format (more readable diffs)
  # ==========================================
  # "ssh/christian/shared/info_ewolutions_de.age" = {
  #   publicKeys = [
  #     christian_pub
  #     offnix_host_pub
  #     devnix_host_pub
  #   ];
  #   armor = true;
  # };
}
