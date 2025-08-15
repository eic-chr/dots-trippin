# NixOS Konfiguration für devnix VM
{ config, pkgs, lib, hostname, usernix, useremail, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Hostname
  networking.hostName = hostname;

  # VM-spezifische Einstellungen
  virtualisation = {
    qemu.guestAgent.enable = true;
  };

  # VM-spezifische System-Pakete
  environment.systemPackages = with pkgs; [
    # Development Tools für VM
    vscode-fhs
    docker
    docker-compose
    postman
    
    # VM Tools
    open-vm-tools  # VMware Tools
  ];

  # Docker für Development
  virtualisation.docker.enable = true;
  users.users.${usernix}.extraGroups = [ "docker" ];

  # VM-spezifische Services
  services.spice-vdagentd.enable = true;  # Für bessere VM-Integration
}
