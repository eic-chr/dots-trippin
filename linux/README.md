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
- Office system with LibreOffice, TeamViewer
- Users: `christian` and `charlotte`
- Charlotte uses German MacBook keyboard layout
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

### Building Only (without switching)

```bash
make build-devnix
make build-offnix
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
   - `thunderbird.nix`

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

## Adding New Systems

1. Create new directory under `hosts/`
2. Add `default.nix` and `hardware-configuration.nix`
3. Import common configuration
4. Add system to `flake.nix` outputs
5. Add make targets if desired