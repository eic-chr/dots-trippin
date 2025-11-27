
{ lib, pkgs, config, ml4wDotsLocal ? null, ... }:
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
            message = "ml4w-dots-xdg: No valid dotsPath/ml4wDotsLocal found.";
          }
          {
            assertion = exists "hypr";
            message = "ml4w-dots-xdg: '${dotsRoot}/hypr' not found. Please point to the ML4W hyprland dotfiles repo root.";
          }
        ];

        # ~/.config/* Links plus optional ~/.local/bin from scripts
        home.file = links // lib.optionalAttrs (exists "scripts") {
          ".local/bin" = {
            source = "${dotsRoot}/scripts";
            recursive = true;
          };
        };

        # Pakete/Runtime-Tools
        home.packages = lib.mkIf cfg.installRuntimePackages (with pkgs; [
          # Core
          hyprland
          xdg-desktop-portal-hyprland

          # Bars/launchers/notifications
          waybar
          rofi-wayland
          dunst
          wlogout

          # Terminal/Editor (Repo benutzt oft kitty)
          kitty

          # Wallpaper / effects
          swww

          # Screenshots / clipboard
          grim
          slurp
          swappy
          wl-clipboard
          cliphist

          # Audio / Brightness / Media
          pamixer
          pavucontrol
          brightnessctl
          playerctl

          # Network / Bluetooth applets (falls gewünscht)
          networkmanagerapplet
          blueman

          # Polkit agent für GUI Auth Dialoge
          polkit_gnome

          # Cursors/Icons/Theming (pragmatisch)
          bibata-cursors
          papirus-icon-theme
          nwg-look
        ]);
      }
    ]
  );
}
