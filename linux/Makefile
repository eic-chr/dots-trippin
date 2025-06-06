.PHONY: help migrate devnix offnix switch-devnix switch-offnix build-devnix build-offnix update clean check status hm-christian hm-charlotte hm-christian-devnix hm-christian-offnix hm-charlotte-offnix hm-switch hm-build hm-check vm-help vm-create-devnix vm-create-offnix vm-start-devnix vm-start-offnix vm-stop-devnix vm-stop-offnix vm-install-devnix vm-install-offnix vm-clean vm-ssh-devnix vm-ssh-offnix vm-iso-download vm-iso-clean

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
	@echo ""
	@echo "VM Testing:"
	@echo "  vm-help       - Show detailed VM commands help"
	@echo "  vm-create-*   - Create VM for testing (devnix/offnix)"
	@echo "  vm-start-*    - Start existing VM (devnix/offnix)"
	@echo "  vm-install-*  - Install NixOS config in VM (devnix/offnix)"

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

# VM Configuration Variables
VM_DIR := ./vms
VM_MEMORY := 4096
VM_DISK_SIZE := 20G
VM_SSH_PORT_DEVNIX := 2222
VM_SSH_PORT_OFFNIX := 2223
NIXOS_ISO_URL := https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
NIXOS_ISO := $(VM_DIR)/nixos-minimal.iso

# VM Help
vm-help:
	@echo "=== QEMU VM Testing for NixOS Configuration ==="
	@echo ""
	@echo "Setup Commands:"
	@echo "  vm-iso-download     - Download NixOS ISO for installation"
	@echo "  vm-create-devnix    - Create devnix VM with 20GB disk"
	@echo "  vm-create-offnix    - Create offnix VM with 20GB disk"
	@echo ""
	@echo "VM Management:"
	@echo "  vm-start-devnix     - Start devnix VM"
	@echo "  vm-start-offnix     - Start offnix VM"
	@echo "  vm-stop-devnix      - Stop devnix VM"
	@echo "  vm-stop-offnix      - Stop offnix VM"
	@echo ""
	@echo "Installation:"
	@echo "  vm-install-devnix   - Install NixOS with devnix config"
	@echo "  vm-install-offnix   - Install NixOS with offnix config"
	@echo ""
	@echo "Access:"
	@echo "  vm-ssh-devnix       - SSH into devnix VM (port 2222)"
	@echo "  vm-ssh-offnix       - SSH into offnix VM (port 2223)"
	@echo ""
	@echo "Cleanup:"
	@echo "  vm-clean            - Remove all VM files"
	@echo "  vm-iso-clean        - Remove downloaded ISO"
	@echo ""
	@echo "VM Details:"
	@echo "  - Memory: $(VM_MEMORY)MB"
	@echo "  - Disk: $(VM_DISK_SIZE)"
	@echo "  - SSH Ports: devnix=2222, offnix=2223"
	@echo "  - VNC: devnix=:1, offnix=:2"

# Download NixOS ISO
vm-iso-download:
	@echo "Downloading NixOS ISO..."
	@mkdir -p $(VM_DIR)
	@if [ ! -f "$(NIXOS_ISO)" ]; then \
		echo "Downloading from $(NIXOS_ISO_URL)..."; \
		curl -L "$(NIXOS_ISO_URL)" -o "$(NIXOS_ISO)"; \
		echo "ISO downloaded to $(NIXOS_ISO)"; \
	else \
		echo "ISO already exists at $(NIXOS_ISO)"; \
	fi

# Create VM disk images
vm-create-devnix: vm-iso-download
	@echo "Creating devnix VM..."
	@mkdir -p $(VM_DIR)
	@if [ ! -f "$(VM_DIR)/devnix.qcow2" ]; then \
		qemu-img create -f qcow2 $(VM_DIR)/devnix.qcow2 $(VM_DISK_SIZE); \
		echo "VM disk created: $(VM_DIR)/devnix.qcow2"; \
		echo "Start VM with: make vm-start-devnix"; \
	else \
		echo "VM disk already exists: $(VM_DIR)/devnix.qcow2"; \
	fi

vm-create-offnix: vm-iso-download
	@echo "Creating offnix VM..."
	@mkdir -p $(VM_DIR)
	@if [ ! -f "$(VM_DIR)/offnix.qcow2" ]; then \
		qemu-img create -f qcow2 $(VM_DIR)/offnix.qcow2 $(VM_DISK_SIZE); \
		echo "VM disk created: $(VM_DIR)/offnix.qcow2"; \
		echo "Start VM with: make vm-start-offnix"; \
	else \
		echo "VM disk already exists: $(VM_DIR)/offnix.qcow2"; \
	fi

# Start VMs
vm-start-devnix:
	@echo "Starting devnix VM..."
	@if [ ! -f "$(VM_DIR)/devnix.qcow2" ]; then \
		echo "VM disk not found. Run 'make vm-create-devnix' first."; \
		exit 1; \
	fi
	@echo "Starting VM with VNC on :1 and SSH on port $(VM_SSH_PORT_DEVNIX)"
	@echo "Connect with VNC: vncviewer localhost:1"
	@echo "Connect with SSH: ssh -p $(VM_SSH_PORT_DEVNIX) root@localhost"
	qemu-system-x86_64 \
		-m $(VM_MEMORY) \
		-smp 2 \
		-hda $(VM_DIR)/devnix.qcow2 \
		-cdrom $(NIXOS_ISO) \
		-boot order=dc \
		-netdev user,id=net0,hostfwd=tcp::$(VM_SSH_PORT_DEVNIX)-:22 \
		-device virtio-net,netdev=net0 \
		-vnc :1 \
		-daemonize \
		-pidfile $(VM_DIR)/devnix.pid

vm-start-offnix:
	@echo "Starting offnix VM..."
	@if [ ! -f "$(VM_DIR)/offnix.qcow2" ]; then \
		echo "VM disk not found. Run 'make vm-create-offnix' first."; \
		exit 1; \
	fi
	@echo "Starting VM with VNC on :2 and SSH on port $(VM_SSH_PORT_OFFNIX)"
	@echo "Connect with VNC: vncviewer localhost:2"
	@echo "Connect with SSH: ssh -p $(VM_SSH_PORT_OFFNIX) root@localhost"
	qemu-system-x86_64 \
		-m $(VM_MEMORY) \
		-smp 2 \
		-hda $(VM_DIR)/offnix.qcow2 \
		-cdrom $(NIXOS_ISO) \
		-boot order=dc \
		-netdev user,id=net0,hostfwd=tcp::$(VM_SSH_PORT_OFFNIX)-:22 \
		-device virtio-net,netdev=net0 \
		-vnc :2 \
		-daemonize \
		-pidfile $(VM_DIR)/offnix.pid

# Stop VMs
vm-stop-devnix:
	@if [ -f "$(VM_DIR)/devnix.pid" ]; then \
		echo "Stopping devnix VM..."; \
		kill `cat $(VM_DIR)/devnix.pid` 2>/dev/null || true; \
		rm -f $(VM_DIR)/devnix.pid; \
		echo "devnix VM stopped."; \
	else \
		echo "devnix VM is not running."; \
	fi

vm-stop-offnix:
	@if [ -f "$(VM_DIR)/offnix.pid" ]; then \
		echo "Stopping offnix VM..."; \
		kill `cat $(VM_DIR)/offnix.pid` 2>/dev/null || true; \
		rm -f $(VM_DIR)/offnix.pid; \
		echo "offnix VM stopped."; \
	else \
		echo "offnix VM is not running."; \
	fi

# SSH into VMs
vm-ssh-devnix:
	@echo "Connecting to devnix VM via SSH..."
	@echo "If this is the first connection, the host key will be different."
	ssh -p $(VM_SSH_PORT_DEVNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost

vm-ssh-offnix:
	@echo "Connecting to offnix VM via SSH..."
	@echo "If this is the first connection, the host key will be different."
	ssh -p $(VM_SSH_PORT_OFFNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost

# Install NixOS configurations in VMs
vm-install-devnix:
	@echo "Installing devnix configuration in VM..."
	@echo "This will:"
	@echo "1. Copy the flake configuration to the VM"
	@echo "2. Generate hardware configuration"
	@echo "3. Install NixOS with devnix configuration"
	@echo ""
	@echo "Make sure the VM is running and accessible via SSH first!"
	@echo "Run: make vm-start-devnix"
	@echo ""
	@read -p "Press Enter to continue or Ctrl+C to abort..."
	@echo "Copying configuration to VM..."
	scp -P $(VM_SSH_PORT_DEVNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r . root@localhost:/tmp/nixos-config/
	@echo "Installing NixOS..."
	ssh -p $(VM_SSH_PORT_DEVNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost '\
		cd /tmp/nixos-config && \
		nixos-generate-config --root /mnt && \
		cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/devnix/ && \
		nixos-install --flake .#devnix --root /mnt && \
		echo "Installation complete! Reboot the VM to boot into your new system."'

vm-install-offnix:
	@echo "Installing offnix configuration in VM..."
	@echo "This will:"
	@echo "1. Copy the flake configuration to the VM"
	@echo "2. Generate hardware configuration"
	@echo "3. Install NixOS with offnix configuration"
	@echo ""
	@echo "Make sure the VM is running and accessible via SSH first!"
	@echo "Run: make vm-start-offnix"
	@echo ""
	@read -p "Press Enter to continue or Ctrl+C to abort..."
	@echo "Copying configuration to VM..."
	scp -P $(VM_SSH_PORT_OFFNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r . root@localhost:/tmp/nixos-config/
	@echo "Installing NixOS..."
	ssh -p $(VM_SSH_PORT_OFFNIX) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost '\
		cd /tmp/nixos-config && \
		nixos-generate-config --root /mnt && \
		cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/offnix/ && \
		nixos-install --flake .#offnix --root /mnt && \
		echo "Installation complete! Reboot the VM to boot into your new system."'

# Cleanup
vm-clean:
	@echo "Cleaning up VM files..."
	@make vm-stop-devnix 2>/dev/null || true
	@make vm-stop-offnix 2>/dev/null || true
	@rm -rf $(VM_DIR)/*.qcow2 $(VM_DIR)/*.pid
	@echo "VM files cleaned up."

vm-iso-clean:
	@echo "Removing NixOS ISO..."
	@rm -f $(NIXOS_ISO)
	@echo "ISO removed."
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
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager switch --flake .#christian@devnix; \
	else \
		nix-shell -p home-manager --run "home-manager switch --flake .#christian@devnix"; \
	fi

hm-christian-offnix:
	@echo "Switching Christian's home-manager configuration on offnix..."
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager switch --flake .#christian@offnix; \
	else \
		nix-shell -p home-manager --run "home-manager switch --flake .#christian@offnix"; \
	fi

hm-charlotte-offnix:
	@echo "Switching Charlotte's home-manager configuration on offnix..."
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager switch --flake .#charlotte@offnix; \
	else \
		nix-shell -p home-manager --run "home-manager switch --flake .#charlotte@offnix"; \
	fi

# Current user home-manager (auto-detect)
hm-switch:
	@USER=$$(whoami); \
	HOSTNAME=$$(hostname); \
	if [ "$$USER" = "christian" ]; then \
		echo "Switching Christian's home-manager on $$HOSTNAME..."; \
		if command -v home-manager >/dev/null 2>&1; then \
			home-manager switch --flake ".#christian@$$HOSTNAME"; \
		else \
			nix-shell -p home-manager --run "home-manager switch --flake '.#christian@$$HOSTNAME'"; \
		fi; \
	elif [ "$$USER" = "charlotte" ] && [ "$$HOSTNAME" = "offnix" ]; then \
		echo "Switching Charlotte's home-manager on $$HOSTNAME..."; \
		if command -v home-manager >/dev/null 2>&1; then \
			home-manager switch --flake ".#charlotte@$$HOSTNAME"; \
		else \
			nix-shell -p home-manager --run "home-manager switch --flake '.#charlotte@$$HOSTNAME'"; \
		fi; \
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
		if command -v home-manager >/dev/null 2>&1; then \
			home-manager build --flake ".#christian@$$HOSTNAME"; \
		else \
			nix-shell -p home-manager --run "home-manager build --flake '.#christian@$$HOSTNAME'"; \
		fi; \
	elif [ "$$USER" = "charlotte" ] && [ "$$HOSTNAME" = "offnix" ]; then \
		echo "Building Charlotte's home-manager on $$HOSTNAME..."; \
		if command -v home-manager >/dev/null 2>&1; then \
			home-manager build --flake ".#charlotte@$$HOSTNAME"; \
		else \
			nix-shell -p home-manager --run "home-manager build --flake '.#charlotte@$$HOSTNAME'"; \
		fi; \
	else \
		echo "Error: Unsupported user/host combination: $$USER@$$HOSTNAME"; \
		exit 1; \
	fi

# Check home-manager configurations
hm-check:
	@echo "Checking home-manager configurations..."
	@echo "Christian@devnix:"
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager build --flake .#christian@devnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	else \
		nix-shell -p home-manager --run "home-manager build --flake .#christian@devnix --dry-run" >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	fi
	@echo "Christian@offnix:"
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager build --flake .#christian@offnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	else \
		nix-shell -p home-manager --run "home-manager build --flake .#christian@offnix --dry-run" >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	fi
	@echo "Charlotte@offnix:"
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager build --flake .#charlotte@offnix --dry-run >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	else \
		nix-shell -p home-manager --run "home-manager build --flake .#charlotte@offnix --dry-run" >/dev/null 2>&1 && echo "  ✓ Valid" || echo "  ✗ Invalid"; \
	fi