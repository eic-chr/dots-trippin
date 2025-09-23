{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;

  cfg = config.programs.nwgDockHyprland;

  # Upstream reference:
  # https://github.com/mylinuxforwork/dotfiles/tree/main/dotfiles/.config/nwg-dock-hyprland
  defaultColorsCss = ''
    /*
    * Css Colors
    * Generated with Matugen
    */
    @define-color blur_background rgba(26, 17, 15, 0.3);
    @define-color blur_background8 rgba(26, 17, 15, 0.8);

        @define-color background #1a110f;

        @define-color error #ffb4ab;

        @define-color error_container #93000a;

        @define-color inverse_on_surface #392e2b;

        @define-color inverse_primary #8f4c35;

        @define-color inverse_surface #f1dfda;

        @define-color on_background #f1dfda;

        @define-color on_error #690005;

        @define-color on_error_container #ffdad6;

        @define-color on_primary #55200c;

        @define-color on_primary_container #ffdbd0;

        @define-color on_primary_fixed #390c00;

        @define-color on_primary_fixed_variant #723520;

        @define-color on_secondary #442a21;

        @define-color on_secondary_container #ffdbd0;

        @define-color on_secondary_fixed #2c160e;

        @define-color on_secondary_fixed_variant #5d4036;

        @define-color on_surface #f1dfda;

        @define-color on_surface_variant #d8c2bb;

        @define-color on_tertiary #3a3005;

        @define-color on_tertiary_container #f3e2a7;

        @define-color on_tertiary_fixed #221b00;

        @define-color on_tertiary_fixed_variant #51461a;

        @define-color outline #a08d87;

        @define-color outline_variant #53433f;

        @define-color primary #ffb59d;

        @define-color primary_container #723520;

        @define-color primary_fixed #ffdbd0;

        @define-color primary_fixed_dim #ffb59d;

        @define-color scrim #000000;

        @define-color secondary #e7bdb0;

        @define-color secondary_container #5d4036;

        @define-color secondary_fixed #ffdbd0;

        @define-color secondary_fixed_dim #e7bdb0;

        @define-color shadow #000000;

        @define-color source_color #f96732;

        @define-color surface #1a110f;

        @define-color surface_bright #423733;

        @define-color surface_container #271d1b;

        @define-color surface_container_high #322825;

        @define-color surface_container_highest #3d322f;

        @define-color surface_container_low #231917;

        @define-color surface_container_lowest #140c0a;

        @define-color surface_dim #1a110f;

        @define-color surface_tint #ffb59d;

        @define-color surface_variant #53433f;

        @define-color tertiary #d7c68d;

        @define-color tertiary_container #51461a;

        @define-color tertiary_fixed #f3e2a7;

        @define-color tertiary_fixed_dim #d7c68d;
  '';

  defaultStyleCss = ''
    @import url("colors.css");

    window {
      	background: @surface;
    	border-radius: 10px;
    	border-style: solid;
    	border-width: 3px;
    	border-color: @primary;
    }

    #box {
      	/* Define attributes of the box surrounding icons here */
      	padding: 10px;
    }

    #active {
    	/* This is to underline the button representing the currently active window */
    	border-bottom: solid 0px;
    	border-color: @primary;
    }

    button, image {
    	background: none;
    	border-style: none;
    	box-shadow: none;
    	color: @primary;
    }

    button {
    	padding: 4px;
    	margin-left: 4px;
    	margin-right: 4px;
    	color: @primary;
    	font-size: 12px
    }

    button:hover {
    	background-color: @primary_container;
    	border-radius: 10px;
    }

    button:focus {
    	box-shadow: none;
    }
  '';

  defaultLaunchSh = ''
    #!/usr/bin/env bash
    #    ___           __
    #   / _ \___  ____/ /__
    #  / // / _ \/ __/  '_/
    # /____/\___/\__/_/\_\
    #

    if [ ! -f $HOME/.config/ml4w/settings/dock-disabled ]; then
        killall nwg-dock-hyprland
        sleep 0.5
        nwg-dock-hyprland -i 32 -w 5 -mb 10 -x -s style.css -c "rofi -show drun"
    else
        echo ":: Dock disabled"
    fi
  '';
in
{
  options.programs.nwgDockHyprland = {
    enable = mkEnableOption "Provision nwg-dock-hyprland config (colors.css, style.css, launch.sh)";

    installPackage = mkOption {
      type = types.bool;
      default = true;
      description = "Install the nwg-dock-hyprland package.";
    };

    colorsCss = mkOption {
      type = types.lines;
      default = defaultColorsCss;
      description = "Content for ~/.config/nwg-dock-hyprland/colors.css";
    };

    styleCss = mkOption {
      type = types.lines;
      default = defaultStyleCss;
      description = "Content for ~/.config/nwg-dock-hyprland/style.css";
    };

    launchSh = mkOption {
      type = types.lines;
      default = defaultLaunchSh;
      description = "Content for ~/.config/nwg-dock-hyprland/launch.sh (will be marked executable)";
    };
  };

  config = mkIf cfg.enable {
    xdg.enable = true;

    # Install runtime package if requested
    home.packages = mkIf cfg.installPackage [ pkgs.nwg-dock-hyprland ];

    # Files under ~/.config/nwg-dock-hyprland
    xdg.configFile."nwg-dock-hyprland/colors.css".text = cfg.colorsCss;
    xdg.configFile."nwg-dock-hyprland/style.css".text = cfg.styleCss;

    home.file.".config/nwg-dock-hyprland/launch.sh" = {
      text = cfg.launchSh;
      executable = true;
    };
  };
}
