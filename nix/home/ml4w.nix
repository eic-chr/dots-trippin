{ lib, pkgs, config, ml4wDots, ... }:
let cfg = config.programs.ml4wDotsXdg;
in {
  options.programs.ml4wDotsXdg = {
    enable = lib.mkEnableOption "Link ML4W Hyprland Dotfiles into XDG config";
    excludeDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Which repo subdirs to NOT link into ~/.config";
    };
    installRuntimePackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description =
        "Install a pragmatic set of runtime packages for Hyprland + ML4W";
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description =
        "Enable verbose evaluation and activation logging for ml4w dots linking";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    # Pakete/Runtime-Tools
    home.packages = lib.mkIf cfg.installRuntimePackages [
      # Bars/launchers/notifications
      pkgs.waybar
      pkgs.waypaper
      pkgs.dunst
      pkgs.wlogout

      # Terminal/Editor (Repo benutzt oft kitty)
      pkgs.kitty

      # Wallpaper / effects
      pkgs.swww

      # Screenshots / clipboard
      pkgs.grim
      pkgs.grimblast
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

      pkgs.hyprshade
      pkgs.hyprpaper
      pkgs.gum
      pkgs.figlet
      pkgs.fastfetch
      pkgs.qt6Packages.qt6ct
      pkgs.walker
      pkgs.wget
    ];
  }]);
}
