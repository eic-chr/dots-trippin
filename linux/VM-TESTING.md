# VM Testing Guide for NixOS Configuration

This guide covers testing your NixOS configuration using QEMU virtual machines before deploying to real hardware.

## Overview

The VM testing system allows you to:
- Test NixOS configurations in isolated environments
- Validate changes before applying to production systems
- Experiment with different configurations safely
- Automate the testing process

## Prerequisites

### Required Software

Install the following packages on your system:

**On NixOS:**
```bash
nix-env -iA nixos.qemu nixos.curl nixos.openssh
```

**On Ubuntu/Debian:**
```bash
sudo apt install qemu-system-x86 qemu-utils curl openssh-client
```

**On macOS:**
```bash
brew install qemu curl
```

### System Requirements

- At least 8GB RAM (4GB allocated to VM)
- 25GB free disk space per VM
- VNC viewer (optional, for GUI access)

## Quick Start

### 1. Create and Start a VM

```bash
# For devnix configuration
make vm-create-devnix
make vm-start-devnix

# For offnix configuration  
make vm-create-offnix
make vm-start-offnix
```

### 2. Access the VM

**Via VNC (GUI):**
```bash
# devnix VM
vncviewer localhost:1

# offnix VM
vncviewer localhost:2
```

**Via SSH (after NixOS installation):**
```bash
# devnix VM
make vm-ssh-devnix
# or: ssh -p 2222 root@localhost

# offnix VM
make vm-ssh-offnix  
# or: ssh -p 2223 root@localhost
```

### 3. Install NixOS Configuration

**Manual installation:**
1. Connect via VNC to see the NixOS live environment
2. Follow the installation process
3. Use `make vm-install-devnix` or `make vm-install-offnix`

**Automated installation:**
```bash
./vm-setup.sh setup devnix
./vm-setup.sh setup offnix
```

## Available Make Targets

### VM Management
```bash
make vm-help              # Show all VM commands
make vm-create-devnix     # Create devnix VM disk
make vm-create-offnix     # Create offnix VM disk
make vm-start-devnix      # Start devnix VM
make vm-start-offnix      # Start offnix VM
make vm-stop-devnix       # Stop devnix VM
make vm-stop-offnix       # Stop offnix VM
```

### Installation
```bash
make vm-install-devnix    # Install NixOS with devnix config
make vm-install-offnix    # Install NixOS with offnix config
```

### Access
```bash
make vm-ssh-devnix        # SSH into devnix VM
make vm-ssh-offnix        # SSH into offnix VM
```

### Maintenance
```bash
make vm-clean             # Remove all VM files
make vm-iso-download      # Download NixOS ISO
make vm-iso-clean         # Remove downloaded ISO
```

## VM Setup Script

The `vm-setup.sh` script provides a more user-friendly interface:

### Basic Usage
```bash
./vm-setup.sh help                    # Show help
./vm-setup.sh setup devnix           # Complete automated setup
./vm-setup.sh create devnix          # Create VM only
./vm-setup.sh start devnix           # Start existing VM
./vm-setup.sh stop devnix            # Stop running VM
./vm-setup.sh install devnix         # Install NixOS (VM must be running)
./vm-setup.sh ssh devnix             # SSH into VM
./vm-setup.sh clean                  # Remove all VM files
```

### Automated Full Setup
```bash
# This will:
# 1. Download NixOS ISO
# 2. Create VM disk
# 3. Start VM
# 4. Wait for SSH
# 5. Partition disk
# 6. Install NixOS with your configuration
./vm-setup.sh setup devnix
```

## VM Configuration Details

### Network Configuration
- **devnix VM**: SSH port 2222, VNC port 5901 (:1)
- **offnix VM**: SSH port 2223, VNC port 5902 (:2)
- NAT networking with port forwarding
- Internet access available in VMs

### Hardware Specifications
- **Memory**: 4GB RAM
- **CPU**: 2 virtual cores
- **Disk**: 20GB virtual disk
- **Boot**: UEFI with legacy BIOS fallback
- **Network**: virtio-net adapter

### File Locations
- **VM disks**: `./vms/*.qcow2`
- **NixOS ISO**: `./vms/nixos-minimal.iso`
- **PID files**: `./vms/*.pid`

## Testing Workflow

### 1. Development Cycle
```bash
# 1. Make changes to your configuration
vim hosts/devnix/default.nix

# 2. Test in VM
make vm-start-devnix
make vm-install-devnix

# 3. Verify the installation
make vm-ssh-devnix

# 4. Apply to real system when satisfied
make devnix
```

### 2. Testing Multiple Configurations
```bash
# Test both configurations
./vm-setup.sh setup devnix &
./vm-setup.sh setup offnix &
wait

# Access them separately
make vm-ssh-devnix    # Terminal 1
make vm-ssh-offnix    # Terminal 2
```

### 3. Configuration Validation
```bash
# Build configurations without installing
make build-devnix
make build-offnix

# Check flake syntax
make check

# Test home-manager configs
make hm-check
```

## Troubleshooting

### VM Won't Start
```bash
# Check if QEMU is installed
which qemu-system-x86_64

# Check if VM is already running
ps aux | grep qemu

# Clean up and retry
make vm-clean
make vm-create-devnix
```

### SSH Connection Failed
```bash
# Wait for VM to fully boot (may take 2-3 minutes)
# Check if SSH port is open
netstat -an | grep 2222

# Try with verbose SSH
ssh -v -p 2222 root@localhost
```

### Installation Failed
```bash
# Check VM has enough resources
# Ensure at least 8GB system RAM
# Check disk space: df -h

# Try manual installation via VNC
vncviewer localhost:1
```

### VNC Connection Issues
```bash
# Install VNC viewer
# On Ubuntu: sudo apt install tigervnc-viewer
# On macOS: brew install --cask vnc-viewer

# Alternative: use QEMU monitor
telnet localhost 2224  # For devnix
```

## Advanced Usage

### Custom VM Configuration
Edit the Makefile variables:
```makefile
VM_MEMORY := 8192        # 8GB RAM
VM_DISK_SIZE := 40G      # 40GB disk
```

### Automated Testing Pipeline
```bash
#!/bin/bash
# test-pipeline.sh

# Test all configurations
for config in devnix offnix; do
    echo "Testing $config..."
    ./vm-setup.sh setup $config
    
    # Run tests in VM
    ssh -p $(($config == "devnix" ? 2222 : 2223)) root@localhost \
        "nixos-rebuild test --flake /etc/nixos#$config"
    
    ./vm-setup.sh stop $config
done
```

### Snapshot and Restore
```bash
# Create snapshot before changes
qemu-img snapshot -c before-changes vms/devnix.qcow2

# Restore snapshot if needed
qemu-img snapshot -a before-changes vms/devnix.qcow2

# List snapshots
qemu-img snapshot -l vms/devnix.qcow2
```

## Integration with CI/CD

### GitHub Actions Example
```yaml
name: Test NixOS Configuration
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Nix
        uses: cachix/install-nix-action@v20
      - name: Test configurations
        run: |
          cd linux
          nix flake check
          make build-devnix
          make build-offnix
```

## Security Considerations

- VMs use NAT networking (isolated from host network)
- SSH host key checking disabled for convenience
- Root access without password in VMs
- Use only for testing, not production

## Performance Tips

- Allocate adequate RAM to avoid swapping
- Use SSD storage for better VM performance  
- Enable hardware virtualization (KVM on Linux)
- Close unnecessary applications when running VMs

## Cleanup

### Regular Cleanup
```bash
# Remove old generations
make clean

# Remove VM files
make vm-clean

# Remove ISO
make vm-iso-clean
```

### Complete Reset
```bash
# Remove everything
rm -rf vms/
rm -f result result-*
```

This VM testing setup provides a safe, reproducible way to test your NixOS configurations before deploying them to production systems.