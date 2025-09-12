{ config, lib, pkgs, hyprlandDots, ... }:
# Home-Manager module that links JaKooLit's Hyprland-Dots into ~/.config
#
# Usage:
# - Ensure your flake passes `hyprlandDots = inputs.hyprland-dots` via specialArgs (done in flake.nix).
# - Import this module in the user's Home-Manager config.
# - Consider disabling your own Hyprland/Rofi/Waybar HM configs to avoid conflicts, since these dots ship their own.
#
# Notes:
# - This module only symlinks dotfiles and installs common runtime dependencies.
# - It does not enable HM modules for waybar/rofi/etc., to avoid managing their options when using external configs.
let
  cfgRoot = "${hyprlandDots}/config";

  # Candidate config directories provided by Hyprland-Dots.
  # We conditionally link only those that exist in the repo version you pin.
  # Link all provided configs including "hypr" to use JaKooLit's Hyprland setup
  linkable = [
    "hypr"
    "waybar"
    "rofi"
    "kitty"
    "wlogout"
    "swaync"
    "ags"
    "dunst"
    "swww"
    "hyprlock"
    "hypridle"
    "hyprpaper"
  ];

  # Build an xdg.configFile fragment for each existing directory in the dots repo.
  mkConfigLinks =
    lib.mkMerge (map
      (name:
        lib.optionalAttrs (builtins.pathExists "${cfgRoot}/${name}") {
          "${name}" = {
            source = "${cfgRoot}/${name}";
            recursive = true;
          };
        }
      )
      linkable);
in
{
  # Common tools the dots use (adjust as needed)
  home.packages = with pkgs; [
    # launchers / bars / session
    rofi
    waybar
    wlogout
    swww
    swaynotificationcenter

    # hypr-utils
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    jq

    # media / brightness / screenshots
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
    swappy

    # file manager often referenced
    xfce.thunar
    gvfs
    xfce.tumbler
    ffmpegthumbnailer

    # theming that’s commonly used with the dots
    papirus-icon-theme

    # KDE Wallet (KWallet) for secrets storage
    kdePackages.kwallet
    kdePackages.kwalletmanager
  ];

  # Symlink Hyprland-Dots configs to ~/.config/<name>
  xdg.configFile = mkConfigLinks;

  # Optional niceties:
  # - make sure the XDG base dirs exist
  xdg.enable = true;

  # If you keep your own HM Hyprland module enabled, it may conflict with these external dotfiles.
  # Prefer one or the other for Hypr config ownership to avoid surprises.
  #
  # You can enforce mutual exclusivity by uncommenting:
  #
  # assertions = [
  #   {
  #     assertion = !(config.wayland.windowManager.hyprland.enable or false);
  #     message = "kool-dots.nix: Disable your HM Hyprland module when using JaKooLit's Hyprland-Dots.";
  #   }
  # ];
}
