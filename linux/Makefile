.PHONY: help migrate devnix offnix switch-devnix switch-offnix build-devnix build-offnix update clean check status hm-christian hm-charlotte hm-christian-devnix hm-christian-offnix hm-charlotte-offnix hm-switch hm-build hm-check

# Default target
help:
	@echo "NixOS Flake Management Commands:"
	@echo ""
	@echo "Migration:"
	@echo "  migrate       - Migrate from old configuration to new flake-based setup"
	@echo "  setup         - Fix Git ownership issues (run once if needed)"
	@echo ""
	@echo "Daily Usage:"
	@echo "  devnix        - Build and switch to devnix configuration"
	@echo "  offnix        - Build and switch to offnix configuration"
	@echo ""
	@echo "Advanced:"
	@echo "  switch-devnix - Switch to devnix configuration"
	@echo "  switch-offnix - Switch to offnix configuration"
	@echo "  build-devnix  - Build devnix configuration without switching"
	@echo "  build-offnix  - Build offnix configuration without switching"
	@echo ""
	@echo "Home-Manager Only (faster):"
	@echo "  hm-christian  - Switch Christian's home-manager config (current host)"
	@echo "  hm-charlotte  - Switch Charlotte's home-manager config (offnix only)"
	@echo "  hm-switch     - Switch current user's home-manager config"
	@echo "  hm-build      - Build current user's home-manager config"
	@echo "  hm-check      - Check home-manager configurations"
	@echo ""
	@echo "Maintenance:"
	@echo "  update        - Update flake inputs"
	@echo "  clean         - Clean old generations"
	@echo "  check         - Check flake configuration syntax"
	@echo "  status        - Show current system and flake status"
	@echo ""
	@echo "Current hostname: $$(hostname)"
	@echo "Current user: $$(whoami)"
	@echo "Flake location: $$(pwd)"

# Migration from old configuration
migrate:
	@echo "Starting migration to flake-based configuration..."
	chmod +x ./migrate-to-flakes.sh
	./migrate-to-flakes.sh

# Fix Git ownership issues
setup:
	@echo "Setting up Git repository and ownership..."
	@if [ ! -d ../.git ]; then \
		echo "Initializing Git repository in parent directory..."; \
		cd .. && git init && git add . && git commit -m "Initial flake configuration"; \
	else \
		echo "Adding current changes to Git..."; \
		cd .. && git add . && git commit -m "Update configuration" || echo "No changes to commit"; \
	fi
	@echo "Adding safe directory for root..."
	doas git config --global --add safe.directory $$(cd .. && pwd)
	@echo "Setup complete!"

# Quick host switching
devnix: switch-devnix

offnix: switch-offnix

# Switch commands
switch-devnix:
	@echo "Switching to devnix configuration..."
	doas nixos-rebuild switch --flake .#devnix

switch-offnix:
	@echo "Switching to offnix configuration..."
	doas nixos-rebuild switch --flake .#offnix

# Build without switching
build-devnix:
	@echo "Building devnix configuration..."
	nixos-rebuild build --flake .#devnix

build-offnix:
	@echo "Building offnix configuration..."
	nixos-rebuild build --flake .#offnix

# Maintenance commands
update:
	@echo "Updating flake inputs..."
	nix flake update
	@echo "Updated. Run 'make <hostname>' to apply updates."

clean:
	@echo "Cleaning old generations..."
	doas nix-collect-garbage -d
	nix-collect-garbage -d
	@echo "Cleanup completed."

check:
	@echo "Checking flake configuration..."
	nix flake check
	@echo "Configuration check passed."

status:
	@echo "=== System Status ==="
	@echo "Hostname: $$(hostname)"
	@echo "NixOS Generation: $$(doas nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1)"
	@echo "Flake Status:"
	@nix flake metadata . 2>/dev/null || echo "  No flake lock found"
	@echo ""
	@echo "=== Available Hosts ==="
	@echo "Configured hosts in this flake:"
	@ls -1 hosts/ | grep -v common.nix | grep -v "\.nix$$" || echo "  No host directories found"

# Automatic host detection
auto:
	@HOSTNAME=$$(hostname); \
	if [ "$$HOSTNAME" = "devnix" ]; then \
		echo "Auto-detected devnix, switching..."; \
		make switch-devnix; \
	elif [ "$$HOSTNAME" = "offnix" ]; then \
		echo "Auto-detected offnix, switching..."; \
		make switch-offnix; \
	else \
		echo "Unknown hostname: $$HOSTNAME"; \
		echo "Available hosts: devnix, offnix"; \
		exit 1; \
	fi

# Legacy compatibility (for old workflows)
apply: auto
	@echo "Note: 'make apply' is deprecated. Use 'make <hostname>' instead."

all: auto
	@echo "Note: 'make all' is deprecated. Use 'make <hostname>' instead."

# Home-Manager specific targets
hm-christian: hm-christian-$(shell hostname)

hm-charlotte: hm-charlotte-offnix

# Home-Manager targets for specific hosts
hm-christian-devnix:
	@echo "Switching Christian's home-manager configuration on devnix..."
	home-manager switch --flake .#christian@devnix

hm-christian-offnix:
	@echo "Switching Christian's home-manager configuration on offnix..."
	home-manager switch --flake .#christian@offnix

hm-charlotte-offnix:
	@echo "Switching Charlotte's home-manager configuration on offnix..."
	home-manager switch --flake .#charlotte@offnix

# Current user home-manager (auto-detect)
hm-switch:
	@USER=$$(whoami); \
	HOSTNAME=$$(hostname); \
	if [ "$$USER" = "christian" ]; then \
		echo "Switching Christian's home-manager on $$HOSTNAME..."; \
		home-manager switch --flake ".#christian@$$HOSTNAME"; \
	elif [ "$$USER" = "charlotte" ] && [ "$$HOSTNAME" = "offnix" ]; then \
		echo "Switching Charlotte's home-manager on $$HOSTNAME..."; \
		home-manager switch --flake ".#charlotte@$$HOSTNAME"; \
	else \
		echo "Error: Unsupported user/host combination: $$USER@$$HOSTNAME"; \
		echo "Supported combinations:"; \
		echo "  christian@devnix"; \
		echo "  christian@offnix"; \
		echo "  charlotte@offnix"; \
		exit 1; \
	fi

# Build home-manager without switching
hm-build:
	@USER=$$(whoami); \
	HOSTNAME=$$(hostname); \
	if [ "$$USER" = "christian" ]; then \
		echo "Building Christian's home-manager on $$HOSTNAME..."; \
		home-manager build --flake ".#christian@$$HOSTNAME"; \
	elif [ "$$USER" = "charlotte" ] && [ "$$HOSTNAME" = "offnix" ]; then \
		echo "Building Charlotte's home-manager on $$HOSTNAME..."; \
		home-manager build --flake ".#charlotte@$$HOSTNAME"; \
	else \
		echo "Error: Unsupported user/host combination: $$USER@$$HOSTNAME"; \
		exit 1; \
	fi

# Check home-manager configurations
hm-check:
	@echo "Checking home-manager configurations..."
	@echo "Christian@devnix:"
	@home-manager build --flake .#christian@devnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"
	@echo "Christian@offnix:"
	@home-manager build --flake .#christian@offnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"
	@echo "Charlotte@offnix:"
	@home-manager build --flake .#charlotte@offnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"