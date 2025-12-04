
{ lib, pkgs, config, ml4wDots , ... }:
let
  cfg = config.programs.ml4wDotsXdg;



  # Kandidaten-Verzeichnisse aus dem ML4W-Repo, die typischerweise vorkommen
  candidateDirs = [
    "waybar"
    "rofi"
    "dunst"
    "matugen"
   # "ml4w" 
   "nwg-dock-hyprland"
   "sidepad"
   "walker"
   "waybar"
   "waypaper"
    "wlogout"
    "wofi"
    "swaylock"
    "swayidle"
    "mako"
  ];

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
      description = "Install a pragmatic set of runtime packages for Hyprland + ML4W";
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose evaluation and activation logging for ml4w dots linking";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # assertions = [
        #   # {
        #   #   assertion = dotsRoot != null;
        #   #   message = "ml4w-dots-xdg: No valid dotsPath/ml4wDotsLocal found. dotsPath=${showPath cfg.dotsPath} ml4wDotsLocal=${showPath ml4wDotsLocal}";
        #   # }
        #   {
        #     assertion = (dotsRoot == null) || exists "hypr";
        #     message = "ml4w-dots-xdg: 'hypr' directory not found. If your repo uses a .config root, set dotsPath to that subdirectory (e.g. /home/christian/projects/github/ml4w-dotfiles/.config).";
        #   }
        # ];

        # # Verbose activation logging
        # home.activation.ml4wVerbose = lib.mkIf cfg.verbose (lib.hm.dag.entryAfter ["writeBoundary"] ''
        #   echo "[ml4w] dotsPath=${showPath cfg.dotsPath}"
        #   echo "[ml4w] ml4wDotsLocal=${showPath ml4wDotsLocal}"
        #   echo "[ml4w] dotsRoot=${showPath dotsRoot}"
        #   echo "[ml4w] linkable dirs: ${builtins.concatStringsSep " " filtered}"
        # '');

        # home.file = 
        # lib.genAttrs candidateDirs (name: {
        #   target = ".config/${name}";
        #   source = "${ml4wDots}/dotfiles/.config/${name}";  # das ganze repo — ggf. mit subdir
        #     recursive = true;
        # })
        #   // {
        #     ".config/ml4w-ml4w" = {
        #     target = ".config/ml4w-ml4w";
        #     source = "${ml4wDots}/dotfiles/.config/ml4w";
        #     recursive = true;
        #   };
        #   }
        #   // {
        #     ".config/hypr-ml4w" = {
        #     target = ".config/hypr-ml4w";
        #     source = "${ml4wDots}/dotfiles/.config/hypr";
        #     recursive = true;
        #   };
        # };
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
          pkgs.qt6ct
          pkgs.walker
          pkgs.wget
        ];
      }
    ]
  );
}
