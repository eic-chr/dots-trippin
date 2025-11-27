
{ lib, pkgs, config, ml4wDotsLocal, ... }:
let
  cfg = config.programs.ml4wDotsXdg;

  # Kandidaten-Verzeichnisse aus dem ML4W-Repo, die typischerweise vorkommen
  candidateDirs = [
    "hypr"
    "waybar"
    "rofi"
    "dunst"
    "wlogout"
    "kitty"
    "wofi"
    "swaylock"
    "swayidle"
    "mako"
  ];

  dotsRoot =
    if cfg.dotsPath != null && builtins.pathExists cfg.dotsPath then cfg.dotsPath
    else if ml4wDotsLocal != null && builtins.pathExists ml4wDotsLocal then ml4wDotsLocal
    else null;

  exists = name: dotsRoot != null && builtins.pathExists "${dotsRoot}/${name}";
  filtered = builtins.filter exists candidateDirs;

  mkLink = name: {
    name = ".config/${name}";
    value = {
      source = "${dotsRoot}/${name}";
      recursive = true;
    } // (if builtins.elem name cfg.excludeDirs then { enable = false; } else {});
  };

  links = builtins.listToAttrs (map mkLink filtered);

in {
  options.programs.ml4wDotsXdg = {
    enable = lib.mkEnableOption "Link ML4W Hyprland Dotfiles into XDG config";
    dotsPath = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Override path to local ML4W dotfiles checkout. Falls back to specialArg ml4wDotsLocal.";
    };
    excludeDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Which repo subdirs to NOT link into ~/.config";
    };
    installRuntimePackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install a pragmatic set of runtime packages for Hyprland + ML4W";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = dotsRoot != null;
            message = "ml4w-dots-xdg: No valid dotsPath/ml4wDotsLocal found. ${toString ml4wDotsLocal} is it";
          }
          {
            assertion = exists "hypr";
            message = "ml4w-dots-xdg: 'hypr' directory not found in the configured dotfiles path.";
          }
        ];

        # ~/.config/* Links plus optional ~/.local/bin from scripts
        home.file = (if dotsRoot != null then links else {}) // lib.optionalAttrs (exists "scripts") {
          ".local/bin" = {
            source = "${dotsRoot}/scripts";
            recursive = true;
          };
        };

        # Pakete/Runtime-Tools
        home.packages = lib.mkIf cfg.installRuntimePackages [
          # Core
          pkgs.hyprland
          pkgs."xdg-desktop-portal-hyprland"

          # Bars/launchers/notifications
          pkgs.waybar
          pkgs."rofi-wayland"
          pkgs.dunst
          pkgs.wlogout

          # Terminal/Editor (Repo benutzt oft kitty)
          pkgs.kitty

          # Wallpaper / effects
          pkgs.swww

          # Screenshots / clipboard
          pkgs.grim
          pkgs.slurp
          pkgs.swappy
          pkgs."wl-clipboard"
          pkgs.cliphist

          # Audio / Brightness / Media
          pkgs.pamixer
          pkgs.pavucontrol
          pkgs.brightnessctl
          pkgs.playerctl

          # Network / Bluetooth applets (falls gewünscht)
          pkgs.networkmanagerapplet
          pkgs.blueman

          # Polkit agent für GUI Auth Dialoge
          pkgs.polkit_gnome

          # Cursors/Icons/Theming (pragmatisch)
          pkgs."bibata-cursors"
          pkgs."papirus-icon-theme"
          pkgs."nwg-look"
        ];
      }
    ]
  );
}
