# Secrets README

This directory contains the age/agenix-based secrets setup for SSH keys and other secrets.

Summary
- Secrets are stored as `.age` files under `ssh/<user>/shared/` or `ssh/<user>/<hostname>/`.
- On each host, the NixOS configuration decrypts and copies the secrets into `~/<user>/.ssh/<basename>` with correct permissions.
- Recipients are defined dynamically in `secrets.nix`:
  - Shared keys: user’s public key + all system host public keys.
  - Host-specific keys: user’s public key + that one host’s public key.
- Public keys are not secret; we store them alongside their `.age` files as `.pub` for auditability and easier rekeying.

Directory layout
- `ssh/<user>/shared/*.age`
  - Keys shared across multiple hosts.
  - Example: `ssh/christian/shared/github.age` -> gets deployed to all hosts for christian as `~/.ssh/github`.
- `ssh/<user>/<hostname>/*.age`
  - Host-specific keys.
  - Example: `ssh/christian/offnix/id_ed25519.age` -> only on offnix as `~/.ssh/id_ed25519`.
- Public keys (recommended)
  - For every `.age` file, place a `.pub` file next to it with the same basename:
    - `ssh/christian/shared/github.age` + `ssh/christian/shared/github.pub`
    - `ssh/christian/offnix/id_ed25519.age` + `ssh/christian/offnix/id_ed25519.pub`

Recipients and RULES
- `secrets.nix` dynamically assigns recipients:
  - Per user, using `userPubs = { <user> = "<ssh-ed25519 ...>"; ... }`
  - Per system/host, using `systemPubs = { offnix = "<ssh-ed25519 ...>"; devnix = "<ssh-ed25519 ...>"; ... }`
- Shared entries → recipients: `[ userPub ] ++ all systemPubs`
- Host entries → recipients: `[ userPub ] ++ [ hostPub ]`
- This ensures:
  - The user can edit their secrets locally using their private key.
  - The target host can decrypt on activation using its host private key.
  - Other users cannot decrypt other users’ secrets.

NixOS deployment behavior (already wired up)
- Decryption happens during the NixOS activation phase (no permanent daemon).
- Files are copied (not symlinked) to `~/.ssh/<basename>` with:
  - mode `600`
  - owner `<user>`
  - group `users`
- `~/.ssh` is created for each user with `0700`.
- The host identity for decryption is the host SSH private key at `/etc/ssh/ssh_host_ed25519_key`.

Workflow to add/update a key
1) Add or update public keys in RULES
- Edit `secrets.nix`:
  - Add/update `userPubs.<user> = "<ssh-ed25519 AAAA... comment>";`
  - Add/update `systemPubs.<hostname> = "<ssh-ed25519 AAAA... comment>";`

2) Create or edit a secret file
- From this directory:
  - Shared: `agenix -e ssh/<user>/shared/<basename>.age`
  - Host: `agenix -e ssh/<user>/<hostname>/<basename>.age`
- This opens `$EDITOR` on a temporary plaintext file. Paste the private key content, save and close.

3) Rekey if recipients changed
- `agenix --rekey`

4) Store public keys next to the `.age` files
- As `.pub` files with the same basename:
  - `ssh/<user>/<scope>/<basename>.pub`

5) Commit
- Commit `secrets.nix`, all `.age` files and `.pub` files.

6) Deploy
- Build/switch your NixOS host as usual. Keys will be copied to `~/.ssh`.

Recommended .gitignore patterns
- Keep these files tracked:
  - `secrets.nix`
  - All `.age` files
  - All `.pub` files
- Example:
  - Allow everything by default, or, if you explicitly ignore `secrets/**`, add negations:
    - `secrets/**`
    - `!secrets/secrets.nix`
    - `!secrets/**/*.age`
    - `!secrets/**/*.pub`

Debugging
- Which secrets are active on a host:
  - `nix eval .#nixosConfigurations.<host>.config.age.secrets --json | jq .`
- Activation logs:
  - `journalctl -b -o cat | grep -i agenix`
- Files on disk:
  - `ls -l /home/<user>/.ssh`

Helper: regenerate .pub files on a target host
- The script below regenerates `.pub` files in the repo from decrypted keys present in `~/.ssh` on the target host.
- It never copies private keys; it only writes corresponding `.pub` files under the repo’s `nix/secrets/ssh/<user>/<hostname>/` (or `shared/` if you pass `--shared`).
- Usage:
  - Copy this file as `nix/secrets/bin/regen-pubkeys.sh`, make it executable (`chmod +x`).
  - Run it on the target host where the keys are deployed.
  - Provide the path to your repo’s `nix/secrets` directory via `--secrets-dir`.
  - By default it writes under `<user>/<hostname>/`. Use `--shared` to write under `<user>/shared/`.

Script: nix/secrets/bin/regen-pubkeys.sh
#!/usr/bin/env bash
set -euo pipefail

# Regenerates .pub files from decrypted SSH keys found in ~/.ssh
# and writes them next to the corresponding .age files in the repo:
#   nix/secrets/ssh/<user>/<hostname>/<basename>.pub  (default)
#   nix/secrets/ssh/<user>/shared/<basename>.pub      (if --shared)
#
# Usage:
#   ./regen-pubkeys.sh --secrets-dir /path/to/repo/nix/secrets [--user <user>] [--host <hostname>] [--shared]
#
# Notes:
# - Only .pub files are written. Private keys are never copied anywhere.
# - Keys are detected as any regular file in ~/.ssh that looks like an OpenSSH private key
#   (file name not ending in .pub, file content begins with '-----BEGIN OPENSSH PRIVATE KEY-----' or 'openssh-key-v1').
#
# Examples:
#   ./regen-pubkeys.sh --secrets-dir "$(git rev-parse --show-toplevel)/nix/secrets"
#   ./regen-pubkeys.sh --secrets-dir "$(pwd)" --user christian --host offnix
#   ./regen-pubkeys.sh --secrets-dir "$(pwd)" --user vincent --shared

# Defaults
TARGET_USER="${USER}"
TARGET_HOST="$(hostname -s)"
WRITE_SHARED="false"
SECRETS_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --secrets-dir)
      SECRETS_DIR="$2"
      shift 2
      ;;
    --user)
      TARGET_USER="$2"
      shift 2
      ;;
    --host)
      TARGET_HOST="$2"
      shift 2
      ;;
    --shared)
      WRITE_SHARED="true"
      shift
      ;;
    -h|--help)
      echo "Usage: $0 --secrets-dir /path/to/repo/nix/secrets [--user <user>] [--host <hostname>] [--shared]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${SECRETS_DIR}" ]]; then
  echo "ERROR: --secrets-dir is required (point to your repo's nix/secrets)" >&2
  exit 1
fi

if [[ ! -d "${SECRETS_DIR}" ]]; then
  echo "ERROR: ${SECRETS_DIR} does not exist or is not a directory" >&2
  exit 1
fi

# Destination directory in repo
if [[ "${WRITE_SHARED}" == "true" ]]; then
  DEST_DIR="${SECRETS_DIR}/ssh/${TARGET_USER}/shared"
else
  DEST_DIR="${SECRETS_DIR}/ssh/${TARGET_USER}/${TARGET_HOST}"
fi

mkdir -p "${DEST_DIR}"

# Iterate over candidate private keys in ~/.ssh
shopt -s nullglob
for key in "${HOME}/.ssh/"*; do
  # Skip directories and public key files
  [[ -f "$key" ]] || continue
  [[ "$key" == *.pub ]] && continue

  # Quick content check to avoid processing random files
  if head -n1 "$key" | grep -Eq '^(-----BEGIN OPENSSH PRIVATE KEY-----|openssh-key-v1)'; then
    base="$(basename "$key")"
    pub="${DEST_DIR}/${base}.pub"

    echo "Generating pubkey for ${key} -> ${pub}"
    if ! ssh-keygen -y -f "$key" > "${pub}.tmp" 2>/dev/null; then
      echo "WARN: ssh-keygen failed for $key; skipping" >&2
      rm -f "${pub}.tmp"
      continue
    fi

    # Normalize to ed25519 format line (if possible) and write
    mv "${pub}.tmp" "${pub}"
    chmod 0644 "${pub}"
  fi
done

echo "Done. Wrote public keys to: ${DEST_DIR}"

Security notes
- Never put unencrypted private keys in this repo.
- `.age` files are safe to commit; they are encrypted to specific recipients.
- `.pub` files are public by design; committing them is safe and helpful for audits and rekeying.
- On hosts, plaintext private keys are placed only in `~/.ssh` (not in the repo) with restrictive permissions.

Tips
- Extract host public key for RULES:
  - On host: `sudo cat /etc/ssh/ssh_host_ed25519_key.pub`
  - Remote: `ssh-keyscan -t ed25519 <hostname> | awk '{print $2" "$3}'`
- Rekey after recipient changes: `agenix --rekey`
- Edit a secret: `agenix -e ssh/<user>/<scope>/<basename>.age`
