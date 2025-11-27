
{ lib, pkgs, config, ml4wDotsLocal ? null, ... }:
let
  cfg = config.programs.ml4wDotsXdg;

  # Helpers for verbosity
  showPath = x:
    let t = builtins.typeOf x;
    in if x == null then "<null>"
       else if t == "path" || t == "string" then toString x
       else "<non-string>";
  traceVal = msg: val: if cfg.verbose then builtins.trace ("[ml4w] " + msg) val else val;

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

  # Resolve repo root and prefer an embedded .config if present
  dotsRootCandidate = traceVal ("dotsPath=" + showPath cfg.dotsPath + " ml4wDotsLocal=" + showPath ml4wDotsLocal) (
    if cfg.dotsPath != null && builtins.pathExists cfg.dotsPath then cfg.dotsPath
    else if ml4wDotsLocal != null && builtins.pathExists ml4wDotsLocal then ml4wDotsLocal
    else null
  );

  dotsRoot = let
    dr =
      if dotsRootCandidate != null && builtins.pathExists "${dotsRootCandidate}/.config"
      then "${dotsRootCandidate}/.config"
      else dotsRootCandidate;
  in traceVal ("resolved dotsRoot=" + showPath dr) dr;

  exists = name: dotsRoot != null && builtins.pathExists "${dotsRoot}/${name}";
  filtered = let
    f = builtins.filter exists candidateDirs;
  in traceVal ("linkable entries under " + showPath dotsRoot + ": " + (builtins.concatStringsSep ", " f)) f;

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

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose evaluation and activation logging for ml4w dots linking";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = dotsRoot != null;
            message = "ml4w-dots-xdg: No valid dotsPath/ml4wDotsLocal found. dotsPath=${showPath cfg.dotsPath} ml4wDotsLocal=${showPath ml4wDotsLocal}";
          }
          {
            assertion = (dotsRoot == null) || exists "hypr";
            message = "ml4w-dots-xdg: 'hypr' directory not found. If your repo uses a .config root, set dotsPath to that subdirectory (e.g. /home/christian/projects/github/ml4w-dotfiles/.config).";
          }
        ];

        # Verbose activation logging
        home.activation.ml4wVerbose = lib.mkIf cfg.verbose (lib.hm.dag.entryAfter ["writeBoundary"] ''
          echo "[ml4w] dotsPath=${showPath cfg.dotsPath}"
          echo "[ml4w] ml4wDotsLocal=${showPath ml4wDotsLocal}"
          echo "[ml4w] dotsRoot=${showPath dotsRoot}"
          echo "[ml4w] linkable dirs: ${builtins.concatStringsSep " " filtered}"
        '');

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
