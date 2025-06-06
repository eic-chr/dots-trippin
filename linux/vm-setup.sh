#!/usr/bin/env bash

# VM Setup Script for NixOS Configuration Testing
# This script automates the process of setting up and installing NixOS in QEMU VMs

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VM_DIR="$SCRIPT_DIR/vms"
VM_MEMORY="4096"
VM_DISK_SIZE="20G"
SSH_PORT_DEVNIX="2222"
SSH_PORT_OFFNIX="2223"
NIXOS_ISO_URL="https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso"
NIXOS_ISO="$VM_DIR/nixos-minimal.iso"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    for cmd in qemu-system-x86_64 qemu-img curl ssh scp; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Missing dependencies: ${missing_deps[*]}"
        echo "Please install the missing dependencies and try again."
        exit 1
    fi
}

# Download NixOS ISO
download_iso() {
    log "Checking for NixOS ISO..."
    mkdir -p "$VM_DIR"
    
    if [ ! -f "$NIXOS_ISO" ]; then
        log "Downloading NixOS ISO from $NIXOS_ISO_URL"
        curl -L "$NIXOS_ISO_URL" -o "$NIXOS_ISO"
        log "ISO downloaded successfully"
    else
        log "ISO already exists at $NIXOS_ISO"
    fi
}

# Create VM disk
create_vm_disk() {
    local vm_name="$1"
    local disk_path="$VM_DIR/${vm_name}.qcow2"
    
    if [ ! -f "$disk_path" ]; then
        log "Creating $vm_name VM disk..."
        qemu-img create -f qcow2 "$disk_path" "$VM_DISK_SIZE"
        log "VM disk created: $disk_path"
    else
        log "VM disk already exists: $disk_path"
    fi
}

# Start VM
start_vm() {
    local vm_name="$1"
    local ssh_port="$2"
    local vnc_port="$3"
    local disk_path="$VM_DIR/${vm_name}.qcow2"
    local pid_file="$VM_DIR/${vm_name}.pid"
    
    if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
        warn "$vm_name VM is already running"
        return 0
    fi
    
    if [ ! -f "$disk_path" ]; then
        error "VM disk not found: $disk_path"
        echo "Run: $0 create $vm_name"
        exit 1
    fi
    
    log "Starting $vm_name VM..."
    log "VNC: localhost:$vnc_port"
    log "SSH: ssh -p $ssh_port root@localhost"
    
    qemu-system-x86_64 \
        -m "$VM_MEMORY" \
        -smp 2 \
        -hda "$disk_path" \
        -cdrom "$NIXOS_ISO" \
        -boot order=dc \
        -netdev user,id=net0,hostfwd=tcp::"$ssh_port"-:22 \
        -device virtio-net,netdev=net0 \
        -vnc ":$vnc_port" \
        -daemonize \
        -pidfile "$pid_file"
    
    log "$vm_name VM started successfully"
}

# Stop VM
stop_vm() {
    local vm_name="$1"
    local pid_file="$VM_DIR/${vm_name}.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log "Stopping $vm_name VM..."
            kill "$pid"
            rm -f "$pid_file"
            log "$vm_name VM stopped"
        else
            warn "$vm_name VM was not running"
            rm -f "$pid_file"
        fi
    else
        warn "$vm_name VM is not running"
    fi
}

# Wait for VM to be accessible via SSH
wait_for_ssh() {
    local ssh_port="$1"
    local timeout=300
    local elapsed=0
    
    log "Waiting for SSH to become available on port $ssh_port..."
    
    while [ $elapsed -lt $timeout ]; do
        if ssh -p "$ssh_port" -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost exit 2>/dev/null; then
            log "SSH is now available"
            return 0
        fi
        sleep 5
        elapsed=$((elapsed + 5))
        echo -n "."
    done
    
    echo
    error "SSH connection timeout after ${timeout}s"
    return 1
}

# Partition and format disk in VM
partition_disk() {
    local ssh_port="$1"
    
    log "Partitioning disk in VM..."
    
    ssh -p "$ssh_port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost << 'EOF'
        set -e
        
        # Partition the disk
        parted /dev/vda -- mklabel gpt
        parted /dev/vda -- mkpart primary 512MiB -8GiB
        parted /dev/vda -- mkpart primary linux-swap -8GiB 100%
        parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
        parted /dev/vda -- set 3 esp on
        
        # Format the partitions
        mkfs.ext4 -L nixos /dev/vda1
        mkswap -L swap /dev/vda2
        mkfs.fat -F 32 -n boot /dev/vda3
        
        # Mount the filesystems
        mount /dev/disk/by-label/nixos /mnt
        mkdir -p /mnt/boot
        mount /dev/disk/by-label/boot /mnt/boot
        swapon /dev/vda2
        
        echo "Disk partitioned and mounted successfully"
EOF
    
    log "Disk partitioning completed"
}

# Install NixOS configuration
install_nixos() {
    local vm_name="$1"
    local ssh_port="$2"
    
    log "Installing NixOS configuration for $vm_name..."
    
    # Copy flake configuration to VM
    log "Copying configuration files..."
    ssh -p "$ssh_port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost "mkdir -p /mnt/etc/nixos"
    scp -P "$ssh_port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r . root@localhost:/mnt/etc/nixos/
    
    # Generate and install
    ssh -p "$ssh_port" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost << EOF
        set -e
        cd /mnt/etc/nixos
        
        # Generate hardware configuration
        nixos-generate-config --root /mnt
        
        # Copy generated hardware config to our flake structure
        cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/$vm_name/
        
        # Install NixOS
        nixos-install --flake .#$vm_name --no-root-passwd
        
        echo "NixOS installation completed successfully!"
EOF
    
    log "NixOS installation completed for $vm_name"
    log "You can now reboot the VM to boot into the new system"
}

# Full automated installation
full_install() {
    local vm_name="$1"
    local ssh_port
    local vnc_port
    
    case "$vm_name" in
        devnix)
            ssh_port="$SSH_PORT_DEVNIX"
            vnc_port="1"
            ;;
        offnix)
            ssh_port="$SSH_PORT_OFFNIX"
            vnc_port="2"
            ;;
        *)
            error "Unknown VM name: $vm_name"
            exit 1
            ;;
    esac
    
    log "Starting full installation for $vm_name"
    
    check_dependencies
    download_iso
    create_vm_disk "$vm_name"
    start_vm "$vm_name" "$ssh_port" "$vnc_port"
    
    if wait_for_ssh "$ssh_port"; then
        partition_disk "$ssh_port"
        install_nixos "$vm_name" "$ssh_port"
        log "Full installation completed! Reboot the VM to use your new NixOS system."
    else
        error "Could not establish SSH connection. Installation aborted."
        stop_vm "$vm_name"
        exit 1
    fi
}

# Show usage
usage() {
    cat << EOF
VM Setup Script for NixOS Configuration Testing

Usage: $0 <command> [options]

Commands:
  setup <vm_name>     - Full automated setup (create, start, install)
  create <vm_name>    - Create VM disk image
  start <vm_name>     - Start VM
  stop <vm_name>      - Stop VM
  install <vm_name>   - Install NixOS configuration (VM must be running)
  ssh <vm_name>       - SSH into VM
  clean              - Remove all VM files
  help               - Show this help

VM Names:
  devnix             - Development configuration
  offnix             - Office configuration

Examples:
  $0 setup devnix    - Complete setup for devnix
  $0 start devnix    - Start devnix VM
  $0 ssh devnix      - SSH into devnix VM
  $0 stop devnix     - Stop devnix VM

VM Details:
  - Memory: ${VM_MEMORY}MB
  - Disk: ${VM_DISK_SIZE}
  - SSH Ports: devnix=2222, offnix=2223
  - VNC Ports: devnix=:1, offnix=:2
EOF
}

# Main script logic
main() {
    case "${1:-help}" in
        setup)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            full_install "$2"
            ;;
        create)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            check_dependencies
            download_iso
            create_vm_disk "$2"
            ;;
        start)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            check_dependencies
            case "$2" in
                devnix) start_vm "$2" "$SSH_PORT_DEVNIX" "1" ;;
                offnix) start_vm "$2" "$SSH_PORT_OFFNIX" "2" ;;
                *) error "Unknown VM: $2"; exit 1 ;;
            esac
            ;;
        stop)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            stop_vm "$2"
            ;;
        install)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            check_dependencies
            case "$2" in
                devnix) 
                    wait_for_ssh "$SSH_PORT_DEVNIX"
                    partition_disk "$SSH_PORT_DEVNIX"
                    install_nixos "$2" "$SSH_PORT_DEVNIX"
                    ;;
                offnix) 
                    wait_for_ssh "$SSH_PORT_OFFNIX"
                    partition_disk "$SSH_PORT_OFFNIX"
                    install_nixos "$2" "$SSH_PORT_OFFNIX"
                    ;;
                *) error "Unknown VM: $2"; exit 1 ;;
            esac
            ;;
        ssh)
            if [ $# -lt 2 ]; then
                error "VM name required"
                usage
                exit 1
            fi
            case "$2" in
                devnix) ssh -p "$SSH_PORT_DEVNIX" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost ;;
                offnix) ssh -p "$SSH_PORT_OFFNIX" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost ;;
                *) error "Unknown VM: $2"; exit 1 ;;
            esac
            ;;
        clean)
            log "Cleaning up all VM files..."
            stop_vm "devnix" 2>/dev/null || true
            stop_vm "offnix" 2>/dev/null || true
            rm -rf "$VM_DIR"
            log "All VM files removed"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"