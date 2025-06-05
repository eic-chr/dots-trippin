#!/bin/bash

# Migration script from old Makefile-based config to new Flake-based config
# Run this script to migrate your existing NixOS system to the new structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME=$(hostname)

echo "=== NixOS Flake Migration Script ==="
echo "Current hostname: $HOSTNAME"
echo "Script directory: $SCRIPT_DIR"

# Check if we're on a supported host
if [[ "$HOSTNAME" != "devnix" && "$HOSTNAME" != "offnix" ]]; then
    echo "Error: This script only supports hostnames 'devnix' or 'offnix'"
    echo "Current hostname is: $HOSTNAME"
    echo "Please update your hostname first or modify the script"
    exit 1
fi

# Backup existing configuration
echo "=== Creating backup of existing configuration ==="
if [ -f /etc/nixos/configuration.nix ]; then
    sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
    echo "Backed up /etc/nixos/configuration.nix"
fi

if [ -f /etc/nixos/hardware-configuration.nix ]; then
    sudo cp /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.backup
    echo "Backed up /etc/nixos/hardware-configuration.nix"
fi

# Copy hardware configuration to new location
echo "=== Setting up hardware configuration ==="
if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix "$SCRIPT_DIR/hosts/$HOSTNAME/hardware-configuration.nix"
    echo "Copied hardware-configuration.nix to hosts/$HOSTNAME/"
else
    echo "Warning: No hardware-configuration.nix found. Generating new one..."
    sudo nixos-generate-config --show-hardware-config > "$SCRIPT_DIR/hosts/$HOSTNAME/hardware-configuration.nix"
    echo "Generated new hardware-configuration.nix"
fi

# Enable flakes if not already enabled
echo "=== Checking Flake support ==="
if ! nix --version | grep -q "flakes"; then
    echo "Enabling flakes temporarily for this rebuild..."
    FLAKE_ENABLE="--extra-experimental-features nix-command --extra-experimental-features flakes"
else
    FLAKE_ENABLE=""
fi

# Check required files exist
echo "=== Checking required configuration files ==="
MISSING_FILES=""

if [ ! -f "$SCRIPT_DIR/p10k-config/.p10k.zsh" ]; then
    echo "Warning: p10k-config/.p10k.zsh not found"
    MISSING_FILES="$MISSING_FILES p10k-config/.p10k.zsh"
fi

if [ ! -f "$SCRIPT_DIR/starship/starship.toml" ]; then
    echo "Warning: starship/starship.toml not found"
    MISSING_FILES="$MISSING_FILES starship/starship.toml"
fi

if [ ! -f "$SCRIPT_DIR/wezterm.lua" ]; then
    echo "Warning: wezterm.lua not found"
    MISSING_FILES="$MISSING_FILES wezterm.lua"
fi

if [ ! -f "$SCRIPT_DIR/thunderbird.nix" ]; then
    echo "Warning: thunderbird.nix not found"
    MISSING_FILES="$MISSING_FILES thunderbird.nix"
fi

if [ -n "$MISSING_FILES" ]; then
    echo "Missing files detected. Creating minimal versions..."
    
    # Create minimal p10k config
    mkdir -p "$SCRIPT_DIR/p10k-config"
    if [ ! -f "$SCRIPT_DIR/p10k-config/.p10k.zsh" ]; then
        echo "# Minimal p10k config" > "$SCRIPT_DIR/p10k-config/.p10k.zsh"
    fi
    
    # Create minimal starship config
    mkdir -p "$SCRIPT_DIR/starship"
    if [ ! -f "$SCRIPT_DIR/starship/starship.toml" ]; then
        cat > "$SCRIPT_DIR/starship/starship.toml" << 'EOF'
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
EOF
    fi
    
    # Create minimal wezterm config
    if [ ! -f "$SCRIPT_DIR/wezterm.lua" ]; then
        cat > "$SCRIPT_DIR/wezterm.lua" << 'EOF'
local wezterm = require 'wezterm'
return {
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 11.0,
}
EOF
    fi
    
    # Create minimal thunderbird config
    if [ ! -f "$SCRIPT_DIR/thunderbird.nix" ]; then
        cat > "$SCRIPT_DIR/thunderbird.nix" << 'EOF'
{
  enable = true;
  profiles = {
    default = {
      isDefault = true;
    };
  };
}
EOF
    fi
fi

# Test the flake configuration
echo "=== Testing flake configuration ==="
cd "$SCRIPT_DIR"
nix $FLAKE_ENABLE flake check || {
    echo "Error: Flake configuration has syntax errors!"
    echo "Please fix the configuration before proceeding."
    exit 1
}

# Build the new configuration
echo "=== Building new configuration ==="
echo "Building configuration for $HOSTNAME..."
nixos-rebuild build $FLAKE_ENABLE --flake ".#$HOSTNAME" || {
    echo "Error: Failed to build new configuration!"
    echo "Please check the configuration and try again."
    exit 1
}

echo "Build successful! The new configuration is ready."
echo ""
echo "=== Ready to switch ==="
echo "To apply the new configuration, run:"
echo "  sudo nixos-rebuild switch --flake '.#$HOSTNAME'"
echo ""
echo "Or use the Makefile:"
echo "  make $HOSTNAME"
echo ""

# Ask if user wants to switch now
read -p "Do you want to switch to the new configuration now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "=== Switching to new configuration ==="
    sudo nixos-rebuild switch $FLAKE_ENABLE --flake ".#$HOSTNAME"
    echo ""
    echo "=== Migration completed successfully! ==="
    echo "Your system is now using the new flake-based configuration."
    echo ""
    echo "Available commands:"
    echo "  make $HOSTNAME     - Switch to this host's configuration"
    echo "  make update        - Update flake inputs"
    echo "  make clean         - Clean old generations"
    echo ""
    echo "Configuration locations:"
    echo "  Host config: hosts/$HOSTNAME/"
    echo "  User config: home-manager/users/"
    echo "  Common config: hosts/common.nix"
else
    echo ""
    echo "Migration prepared but not applied."
    echo "Run 'sudo nixos-rebuild switch --flake \".#$HOSTNAME\"' when ready."
fi

echo ""
echo "=== Post-migration notes ==="
echo "1. The old configuration has been backed up to /etc/nixos/*.backup"
echo "2. You can now use 'make help' to see available commands"
echo "3. User-specific configurations are in home-manager/users/"
echo "4. Host-specific configurations are in hosts/$HOSTNAME/"