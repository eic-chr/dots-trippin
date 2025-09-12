{ config, lib, pkgs, ... }:
# Home-Manager profile variant for offnix users:
# - Enables KooL's Hyprland-Dots (imports ./kool-dots.nix)
# - Explicitly disables the local HM Hyprland module to avoid conflicts
#
# Usage:
# - Import this module for users on the offnix host instead of (or in addition to) your default HM profile.
# - Ensure your flake passes `hyprlandDots = inputs.hyprland-dots` via specialArgs (flake.nix already adjusted).
#
# Notes:
# - This variant relies on system-level Hyprland (nixosPrograms.hyprland) from hosts/hyprland.nix.
# - Rofi HM module is disabled; the Dots provide their own rofi configs.
# - If you still import ./hyprland.nix elsewhere, this will override its HM Hyprland enable flag.
{
  imports = [
    ./kool-dots.nix
  ];

  # Disable the Home-Manager Hyprland module to avoid config collisions with KooL-Dots
  wayland.windowManager.hyprland.enable = lib.mkForce false;

  # Optional: disable HM rofi module since Dots ship their own rofi configs
  programs.rofi.enable = lib.mkForce false;

  # Optional safety assertion (uncomment if you prefer hard failure over mkForce override)
  # assertions = [
  #   {
  #     assertion = !(config.wayland.windowManager.hyprland.enable or false);
  #     message = "offnix-kool.nix: Disable HM Hyprland when using KooL's Hyprland-Dots.";
  #   }
  # ];
}
