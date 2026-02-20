{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd.availableKernelModules = ["ahci" "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = [];
    extraModulePackages = with config.boot.kernelPackages; [nct6687d];
    kernelModules = ["nct6687" "kvm-amd" "sr_mod"];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Use latest kernel.
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f4669cea-81d5-453a-b6b6-b8366b2c872d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3D78-9A53";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/c5de3389-f05d-4f75-8f56-cb3e818a2436";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless.enable = true;
    opengl.driSupport32Bit = true;
  };
}
