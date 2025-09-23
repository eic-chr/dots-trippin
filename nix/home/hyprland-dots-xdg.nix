{ lib
, config
, pkgs
, hyprlandDots ? null
, hyprlandDotsLocal ? null
, ...
}:
# Generic Home-Manager module to link JaKooLit Hyprland-Dots into ~/.config via xdg.configFile.
#
# How to use:
# - Ensure your flake passes `hyprlandDots` (the upstream input) and/or `hyprlandDotsLocal` (a local vendor path)
#   via `specialArgs` (your flake already defines both in mkSpecialArgs).
# - Import this module in your Home-Manager user config.
# - Enable with:
#
#     programs.hyprlandDotsXdg.enable = true;
#
# - Optionally extend which config subdirs are linked:
#
#     programs.hyprlandDotsXdg.linkDirs = [ "dunst" "swww" ];
#
# - Optionally make sure your local overrides are included and/or provide their content:
#
#     programs.hyprlandDotsXdg.ensureLocalInclude = true; # default
#     programs.hyprlandDotsXdg.localIncludeContent = ''
#       # Your machine/user specific overrides go here
#       monitor=eDP-1,2880x1800@60,auto,1.5
#     '';
#
# - Optionally install runtime packages used by the Dots:
#
#     programs.hyprlandDotsXdg.installRuntimePackages = true;
#     # optionally customize:
#     # programs.hyprlandDotsXdg.runtimePackages = with pkgs; [ waybar rofi-wayland ... ];
#
# - Optional WayVNC service (user level):
#
#     programs.hyprlandDotsXdg.enableWayvnc = true;
#     # optionally customize the config content via programs.hyprlandDotsXdg.wayvncConfigText
#
# Notes:
# - This module only links configuration directories. It does NOT enable/disable HM Hyprland or rofi modules.
#   Keep your Hyprland enablement in your existing HM/NixOS modules.
# - Any directory listed below is included "if it exists" in the Dots, so it's safe across Dots versions.
#
let
  inherit (lib) mkIf mkEnableOption mkOption types unique subtractLists;

  cfg = config.programs.hyprlandDotsXdg;

  # Prefer a locally vendored checkout when available, otherwise fall back to the flake input.
  dotsRoot =
    if hyprlandDotsLocal != null && builtins.pathExists "${hyprlandDotsLocal}/config"
    then hyprlandDotsLocal
    else if hyprlandDots != null && builtins.pathExists "${hyprlandDots}/config"
    then hyprlandDots
    else null;

  cfgRoot = if dotsRoot != null then "${dotsRoot}/config" else null;

  patchedCfgRoot =
    if cfg.enable && cfgRoot != null && cfg.patchShebangs
    then pkgs.runCommandLocal "hyprland-dots-config-patched"
      {
        nativeBuildInputs = with pkgs; [ coreutils findutils gnused gnugrep bash ];
      } ''
        set -eu
        mkdir -p "$out"
        cp -r --preserve=mode "${cfgRoot}/." "$out/"
        find "$out" -type f -print0 | while IFS= read -r -d $'\0' f; do
          if head -c 2 "$f" | grep -q '^#!'; then
            sed -i \
              -e '1s|^#!/bin/bash|#!${pkgs.bash}/bin/bash|' \
              "$f" || true
          fi
        done
      ''
    else cfgRoot;

  # Default set based on upstream JaKooLit/Hyprland-Dots "config" tree
  defaultLinkables = [
    "Kvantum"
    "ags"
    "btop"
    "cava"
    "dunst"
    "fastfetch"
    "hypr"
    "hypridle"
    "hyprlock"
    "hyprpaper"
    "kitty"
    "nvim"
    "qt5ct"
    "qt6ct"
    "quickshell"
    "rofi"
    "nwg-dock-hyprland"
    "swww"
    "swappy"
    "swaync"
    "wallust"
    "waybar"
    "wlogout"
  ];

  toLink = unique (subtractLists (defaultLinkables ++ cfg.linkDirs) cfg.excludeDirs);

  linkHypr =
    cfg.enable && patchedCfgRoot != null && builtins.pathExists "${patchedCfgRoot}/hypr"
    && lib.elem "hypr" toLink;

  mkConfigFiles =
    if cfg.enable && patchedCfgRoot != null
    then lib.mkMerge (map
      (name:
        lib.optionalAttrs (builtins.pathExists "${patchedCfgRoot}/${name}") {
          "${name}" = {
            source = "${patchedCfgRoot}/${name}";
            recursive = true;
          };
        })
      toLink)
    else { };
in
{
  options.programs.hyprlandDotsXdg = {
    enable = mkEnableOption "Link JaKooLit Hyprland-Dots via xdg.configFile (replaces stow)";

    linkDirs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "dunst" "swww" ];
      description = ''
        Additional subdirectories under the Dots' config/ to link into ~/.config.
        Only existing directories will be linked.
      '';
    };

    excludeDirs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "rofi" "nvim" ];
      description = ''
        Subdirectories under the Dots' config/ to NOT link into ~/.config.
        Use this to skip or override parts of the upstream Dots.
      '';
    };

    ensureLocalInclude = mkOption {
      type = types.bool;
      default = true;
      description = ''
        When true, append `source = ~/.config/hypr/zz-local.conf` to ~/.config/hypr/hyprland.conf
        if it's missing (idempotent). This allows you to keep machine/user-specific overrides
        managed by Home-Manager without forking upstream hyprland.conf.
      '';
    };

    localIncludeContent = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Optional content to write to ~/.config/hypr/zz-local.conf. If null, the file will not
        be created/managed (but `ensureLocalInclude` may still append the include line).
      '';
    };

    patchShebangs = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Rewrite common shebangs in the Dots' scripts to Nix store interpreter paths
        before linking (avoids reliance on /bin or /usr/bin/env). This does not modify
        upstream sources; it operates on a copied output used for linking.
      '';
    };

    installRuntimePackages = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If true, install a reasonable set of runtime tools used by the Hyprland-Dots
        (rofi, waybar, hyprpaper, screenshots, clipboard, etc.).
      '';
    };

    runtimePackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        ags
        brightnessctl
        ffmpegthumbnailer
        grim
        gvfs
        hypridle
        hyprlock
        hyprpaper
        hyprpicker
        jq
        kdePackages.kwallet
        kdePackages.kwalletmanager
        papirus-icon-theme
        playerctl
        pamixer
        pavucontrol
        rofi-wayland
        nwg-dock-hyprland
        slurp
        swappy
        swaynotificationcenter
        swww
        waybar
        wl-clipboard
        wlogout
        xfce.thunar
        xfce.tumbler
        yad
      ];
      description = "Package set to install when installRuntimePackages = true. The default intentionally excludes wayvnc; use enableWayvnc if you need it.";
    };

    enableWayvnc = mkOption {
      type = types.bool;
      default = false;
      description = "Enable a user-level wayvnc service and provision a config file.";
    };

    wayvncConfigText = mkOption {
      type = types.lines;
      default = ''
        # WayVNC config managed by Home Manager (hyprland-dots-xdg)
        address=127.0.0.1
        enable_auth=true
        username=guacuser
        password=change-me
        # port=5900
      '';
      description = "Content for ~/.config/wayvnc/config when enableWayvnc = true.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = dotsRoot != null;
        message = "hyprland-dots-xdg: Could not locate a valid Hyprland-Dots source. Provide hyprlandDots or hyprlandDotsLocal via specialArgs.";
      }
    ];

    xdg.enable = true;
    xdg.configFile = mkConfigFiles;

    # Optional local include content
    home.file = lib.mkMerge [
      (mkIf (cfg.localIncludeContent != null && linkHypr) {
        ".config/hypr/zz-local.conf".text = cfg.localIncludeContent;
      })
      (mkIf cfg.enableWayvnc {
        ".config/wayvnc/config".text = cfg.wayvncConfigText;
      })
    ];

    # Optionally install runtime packages used by the Dots
    home.packages = mkIf cfg.installRuntimePackages cfg.runtimePackages;

    # Optional WayVNC service and config
    systemd.user.services.wayvnc = mkIf cfg.enableWayvnc {
      Unit = {
        Description = "WayVNC server for Wayland/Hyprland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config %h/.config/wayvnc/config";
        Restart = "on-failure";
        RestartSec = 2;
        Environment = "XDG_RUNTIME_DIR=%t";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # wayvnc config now provided via combined home.file mkMerge above

    # Ensure hyprland.conf includes our local override file
    home.activation.hyprLocalInclude = mkIf (cfg.ensureLocalInclude && linkHypr) (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      conf="$HOME/.config/hypr/hyprland.conf"
      include="source = ~/.config/hypr/zz-local.conf"
      mkdir -p "$HOME/.config/hypr"
      if [ -f "$conf" ] && ! grep -qF "$include" "$conf"; then
        printf "\n# Local overrides (added by Home Manager)\n%s\n" "$include" >> "$conf"
      fi
    '');
  };
}
