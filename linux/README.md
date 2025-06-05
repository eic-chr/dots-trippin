# NixOS Configuration

This directory contains the NixOS configuration for both `devnix` and `offnix` systems using Nix flakes.

## Structure

```
linux/
├── flake.nix                    # Main flake configuration
├── Makefile                     # Convenience commands
├── hosts/
│   ├── common.nix              # Shared configuration for both systems
│   ├── devnix/
│   │   ├── default.nix        # devnix-specific configuration
│   │   └── hardware-configuration.nix
│   └── offnix/
│       ├── default.nix        # offnix-specific configuration
│       └── hardware-configuration.nix
└── home-manager/
    ├── default.nix             # Home-Manager main configuration
    └── users/
        ├── christian.nix      # Christian's user configuration
        └── charlotte.nix      # Charlotte's user configuration
```

## Systems

### devnix
- Development system with Docker, Go tools, VS Code
- User: `christian` with US International keyboard layout
- Bootloader: GRUB on `/dev/sda`

### offnix
- Office system with LibreOffice, TeamViewer, KDE PIM Suite
- Users: `christian` and `charlotte`
- Charlotte uses German MacBook keyboard layout and KMail
- Bootloader: systemd-boot with UEFI

## Usage

### Building and Switching

```bash
# Switch to devnix configuration
make devnix
# or
make switch-devnix

# Switch to offnix configuration
make offnix
# or
make switch-offnix
```

### Home-Manager Only (Faster)

For user-specific configuration changes without full system rebuilds:

```bash
# Current user on current host
make hm-switch

# Specific users
make hm-christian     # Christian (auto-detect host)
make hm-charlotte     # Charlotte (offnix only)

# Host-specific
make hm-christian-devnix
make hm-christian-offnix
make hm-charlotte-offnix
```

### Building Only (without switching)

```bash
# Full system builds
make build-devnix
make build-offnix

# Home-Manager only
make hm-build
make hm-check
```

### Updating

```bash
# Update flake inputs
make update

# Clean old generations
make clean
```

### Manual Commands

```bash
# Build and switch manually
sudo nixos-rebuild switch --flake .#devnix
sudo nixos-rebuild switch --flake .#offnix

# Build only
nixos-rebuild build --flake .#devnix
nixos-rebuild build --flake .#offnix

# Home-Manager standalone
home-manager switch --flake .#christian@devnix
home-manager switch --flake .#charlotte@offnix
```

## Initial Setup

1. **Generate hardware configuration**:
   ```bash
   # On each system, run:
   sudo nixos-generate-config

   # Copy the generated hardware-configuration.nix to the appropriate host directory
   ```

2. **Update UUIDs**: Edit the hardware-configuration.nix files and replace the placeholder UUIDs with the actual ones from your system.

3. **Copy configuration files**: Ensure these files exist in the appropriate locations:
   - `p10k-config/.p10k.zsh`
   - `starship/starship.toml`
   - `wezterm.lua`
   - `thunderbird.nix` (for Christian only)

## Keyboard Configuration

### Christian (US International)
- Automatic setup via systemd service
- Compose key: Right Alt
- Umlauts: Right Alt + " + vowel (ä, ö, ü)

### Charlotte (German MacBook)
- German MacBook layout
- Automatic setup via systemd service
- Compose key: Right Alt

## Troubleshooting

### Keyboard Layout Issues
If keyboard layout doesn't work automatically:

```bash
# For Christian (US International)
setxkbmap us intl
setxkbmap -option compose:ralt

# For Charlotte (German MacBook)
setxkbmap de mac
setxkbmap -option compose:ralt
```

### Service Status
Check if the keyboard service is running:

```bash
systemctl --user status keyboard-setup
```

### Rebuild Issues
If rebuild fails, check:
1. Hardware configuration UUIDs are correct
2. All referenced files exist
3. Syntax is correct: `nix flake check`

## Email Configuration

### Christian
- Uses Thunderbird (configured via Home Manager)
- Configuration imported from `thunderbird.nix`

### Charlotte
- Uses KMail (KDE's email client)
- **Pre-configured account**: charlotte@ewolutions.de
- **SMTP Server**: mail.ewolutions.de (port 587, TLS)
- **IMAP Server**: mail.ewolutions.de (port 993, SSL)
- Part of KDE PIM suite including Kontact, KAddressBook, KOrganizer
- Akonadi database backend automatically configured
- Account setup runs automatically on first login
- Password needs to be entered manually on first KMail start

#### Charlotte's Email Setup Details
- **Identity**: Charlotte Amend (EWolutions - Eickhoff & Wölfing IT Solutions GbR)
- **Automatic services**:
  - `kmail-setup.service` - Configures email account on login
  - `keyboard-setup.service` - Sets German MacBook layout
- **Manual step**: Enter email password when prompted by KMail

## Home-Manager vs System Rebuilds

**Use Home-Manager targets for:**
- Dotfiles changes (shell configs, starship theme)
- User-specific packages
- Application configurations (git, wezterm)
- Much faster (~30 seconds vs 2-5 minutes)

**Use system rebuilds for:**
- System services, hardware changes
- Adding/removing users
- Bootloader or kernel changes

See [HOME-MANAGER.md](HOME-MANAGER.md) for detailed usage guide.

## Adding New Systems

1. Create new directory under `hosts/`
2. Add `default.nix` and `hardware-configuration.nix`
3. Import common configuration
4. Add system to `flake.nix` outputs
5. Add make targets if desired
</edits>
