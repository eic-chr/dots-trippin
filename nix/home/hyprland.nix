{ config, lib, pkgs, hyprlandInput, hyprlandPluginsPkgs, ... }:
{
  # Hyprland configuration (Home Manager)
  #
  # Inspired by:
  # https://raw.githubusercontent.com/notwidow/hyprland/refs/heads/main/hypr/hyprland.conf
  #
  # Notes:
  # - Monitors from the reference config are left as commented examples. Adjust to your setup via `hyprctl monitors`.
  # - Keybindings are adapted to tools available in your flake (kitty, rofi, waybar, hyprlock).
  # - Volume/brightness/media/screenshot bindings use wpctl/brightnessctl/playerctl/grim+slurp+wl-clipboard+swappy.

  # Utilities needed by some keybindings
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
    swappy
    xfce.thunar
    wlogout
    xfce.thunar-archive-plugin
    xfce.tumbler
    ffmpegthumbnailer
    xarchiver
    gvfs
    hyprpaper
    kdePackages.kwallet
    kdePackages.kwalletmanager
    papirus-icon-theme
  ];



  wayland.windowManager.hyprland = {
    enable = true;
    package = (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland;
    plugins = [ hyprlandPluginsPkgs.hyprexpo ];

    xwayland.enable = true;
    systemd.enable = true;


    # You can place non-structured Hyprland config here (comments, examples, etc.)
    extraConfig = ''
      # Example monitor layout (adjust or remove):
      # monitor=DP-2,1920x1080@144,0x0,1
      # workspace=DP-2,1
      # monitor=DVI-D-1,1360x768@60,1920x0,1
      # workspace=DVI-D-1,2
    '';

    settings = {
      # Variables (used in binds)
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$editor" = "kitty -e nvim";
      "$browser" = "firefox";


      # Monitors (safe defaults; change to your actual outputs if desired)
      monitor = [
        "eDP-1,preferred,auto,2"
        # Add more if you have external monitors, e.g.:
        # "HDMI-A-1,1920x1080@60,auto,1"
      ];

      # Input
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        natural_scroll = 0;
        numlock_by_default = 1;
        # force_no_accel = 0;
        # repeat_rate = 50;
        # repeat_delay = 300;
      };

      # General
      general = {
        sensitivity = 2.0;
        apply_sens_to_raw = 0;

        gaps_in = 5;
        gaps_out = 10;

        border_size = 4;
        "col.active_border" = "0xff89b4fa";
        "col.inactive_border" = "0xff313244";

        damage_tracking = "full";
      };

      # Decoration
      decoration = {
        rounding = 8;
        multisample_edges = 0;

        active_opacity = 1.0;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = false;
          size = 3;     # min 1
          passes = 1;   # min 1
          ignore_opacity = false;
        };
      };

      # Animations
      animations = {
        enabled = true;
        animation = [
          "windows,1,8,default,popin 80%"
          "fadeOut,1,8,default"
          "fadeIn,1,8,default"
          "workspaces,1,8,default"
          # "workspaces,1,6,overshot"
        ];
      };

      # Plugins
      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(1e1e2e)";
          workspace_method = "center current"; # [center/first] [workspace]
          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;
        };
      };

      # XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      # Dwindle
      dwindle = {
        pseudotile = false;
      };

      # Window Rules (sample float rules)
      windowrule = [
        "float,nm-connection-editor"
        "float,pavucontrol"
        "float,feh|Viewnior|Gpicview|Gimp|nomacs"
        "float,VirtualBox Manager|qemu|Qemu-system-x86_64"
        "float,xfce4-appfinder"
      ];

      # Keybindings
      bind = [
        # Window switcher
        "ALT, TAB, exec, ~/.config/hypr/cycle_window.sh next"
        "ALT SHIFT, TAB, exec, ~/.config/hypr/cycle_window.sh prev"

        # Workspace overview (Hyprexpo)
        "$mainMod, Space, hyprexpo:expo, toggle"
        # Terminal
        "$mainMod, Return, exec, $terminal"

        # Apps
        "$mainMod SHIFT, F, exec, $fileManager"
        "$mainMod SHIFT, E, exec, $editor"
        "$mainMod SHIFT, W, exec, $browser"

        # App launchers (rofi)
        "ALT, F1, exec, rofi -theme ~/.config/rofi/themes/catppuccin-mocha.rasi -show window"
        "$mainMod, D, exec, rofi -theme ~/.config/rofi/themes/catppuccin-mocha.rasi -show drun -show-icons"
        "ALT, F3, exec, rofi -theme ~/.config/rofi/themes/catppuccin-mocha.rasi -show run"

        # Misc
        "$mainMod, N, exec, nm-connection-editor"
        "$mainMod, P, exec, hyprpicker -a"
        "$mainMod, X, exec, ~/.config/rofi/powermenu.sh"
        "$mainMod CTRL, X, exec, wlogout"
        "CTRL ALT, L, exec, hyprlock"

        # Hyprland actions
        "$mainMod, Q, killactive,"
        "CTRL ALT, Delete, exit,"
        "$mainMod, F, fullscreen,"
        # "$mainMod, Space, togglefloating,"
        "$mainMod, S, pseudo,"

        # Focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Move windows
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        # Resize windows
        "$mainMod CTRL, left, resizeactive, -20 0"
        "$mainMod CTRL, right, resizeactive, 20 0"
        "$mainMod CTRL, up, resizeactive, 0 -20"
        "$mainMod CTRL, down, resizeactive, 0 20"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Send to workspaces
        "ALT, 1, movetoworkspace, 1"
        "ALT, 2, movetoworkspace, 2"
        "ALT, 3, movetoworkspace, 3"
        "ALT, 4, movetoworkspace, 4"
        "ALT, 5, movetoworkspace, 5"
        "ALT, 6, movetoworkspace, 6"
        "ALT, 7, movetoworkspace, 7"
        "ALT, 8, movetoworkspace, 8"
        "ALT, 9, movetoworkspace, 9"
        "ALT, 0, movetoworkspace, 10"

        # Function keys: brightness
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # Function keys: audio via PipeWire
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Function keys: media (playerctl)
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"

        # Screenshots (grim + slurp + wl-clipboard + swappy)
        ", Print, exec, grim - | wl-copy"
        "SUPER, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "CTRL, Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Workspace scroll with mouse + mod
      binde = [
        "$mainMod, mouse_up, resizeactive, 0 -20"
        "$mainMod, mouse_down, resizeactive, 0 20"
        "$mainMod SHIFT, mouse_up, resizeactive, 20 0"
        "$mainMod SHIFT, mouse_down, resizeactive, -20 0"
      ];

      # Autostart
      exec-once = [
        "hyprpaper"
        "waybar"
        "kwalletd6"
      ];
    };
  };
  home.file.".config/hypr/hyprpaper.conf".text = ''
    ipc = on
    splash = false

    # Default wallpaper (managed by Home Manager from nix/home/images/default.jpg)
    preload = ${config.home.homeDirectory}/.config/hypr/wallpapers/default.jpg
    wallpaper = ,${config.home.homeDirectory}/.config/hypr/wallpapers/default.jpg

    # Per-monitor examples:
    # wallpaper = eDP-1,${config.home.homeDirectory}/.config/hypr/wallpapers/laptop.jpg
    # wallpaper = HDMI-A-1,${config.home.homeDirectory}/.config/hypr/wallpapers/desk.jpg
  '';

  # Rofi powermenu (script + theme)
  home.file.".config/rofi/powermenu.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      rofi_cmd="rofi -dmenu -i -p Power -theme ~/.config/rofi/themes/catppuccin-mocha.rasi"

      choices="Lock\nLogout\nSuspend\nReboot\nShutdown"
      choice=$(printf "%b" "$choices" | $rofi_cmd)

      case "$choice" in
        Lock) hyprlock ;;
        Logout) hyprctl dispatch exit ;;
        Suspend) systemctl suspend ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
      esac
    '';
  };

  home.file.".config/rofi/themes/catppuccin-mocha.rasi".text = ''
    * {
      background: #1e1e2eFF;
      background-alt: #313244FF;
      foreground: #cdd6f4FF;
      selected:  #89b4faFF;
      urgent:    #f38ba8FF;
      accent:    #cba6f7FF;
      font: "JetBrainsMono Nerd Font 12";
    }

    window {
      width: 40%;
      border: 2px;
      border-color: @accent;
      padding: 16px;
      background-color: @background;
      border-radius: 12px;
    }

    listview {
      lines: 10;
      columns: 1;
      spacing: 8px;
      cycle: false;
    }

    element {
      padding: 10px 14px;
      background-color: @background-alt;
      text-color: @foreground;
      border: 0px;
      border-radius: 8px;
    }

    element selected {
      background-color: @selected;
      text-color: #1e1e2eFF;
    }

    entry, prompt {
      padding: 10px 12px;
      background-color: @background;
      text-color: @foreground;
      border-radius: 8px;
    }

    message {
      background-color: @background;
      text-color: @foreground;
    }
  '';



  home.file.".config/hypr/wallpapers" = lib.mkIf (builtins.pathExists ./images) {
    source = ./images;
    recursive = true;
  };
  home.file.".config/wlogout/layout".text = ''
label = lock
action = hyprlock
text = Lock
keybind = l

label = logout
action = hyprctl dispatch exit
text = Logout
keybind = e

label = suspend
action = systemctl suspend
text = Sleep
keybind = s

label = reboot
action = systemctl reboot
text = Reboot
keybind = r

label = shutdown
action = systemctl poweroff
text = Shutdown
keybind = p
  '';
  home.file.".config/wlogout/style.css".text = ''
window {
  background-color: rgba(30, 30, 46, 0.6); /* Catppuccin Mocha base */
}

button {
  border-radius: 14px;
  padding: 22px;
  margin: 12px;
  background-color: rgba(49, 50, 68, 0.95); /* surface0 */
  color: #cdd6f4; /* text */
  font-size: 18px;
  border: 2px solid #cba6f7; /* mauve */
}

button:focus, button:hover {
  background-color: #89b4fa; /* blue */
  color: #11111b; /* crust */
  border-color: #b4befe; /* lavender */
}

#lock {
  border-color: #89b4fa; /* blue */
}
#logout {
  border-color: #94e2d5; /* teal */
}
#suspend {
  border-color: #cba6f7; /* mauve */
}
#reboot {
  border-color: #f9e2af; /* yellow */
}
#shutdown {
  border-color: #f38ba8; /* red */
}
  '';

  # Use packaged default icons for wlogout
  home.file.".config/wlogout/icons" = {
    source = "${pkgs.wlogout}/share/wlogout/icons";
    recursive = true;
  };
  home.file.".config/hypr/cycle_window.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      dir="$1"
      # get active workspace id
      ws=$(hyprctl activeworkspace -j | jq -r .id)
      # collect windows on this workspace
      mapfile -t wins < <(hyprctl clients -j | jq -r --argjson ws "$ws" '[.[] | select(.workspace.id == $ws and .mapped == true) | .address] | .[]')
      [ ''${#wins[@]} -le 1 ] && exit 0
      # find focus index
      active=$(hyprctl activewindow -j | jq -r .address)
      idx=0
      for i in "''${!wins[@]}"; do
        if [[ "''${wins[$i]}" == "$active" ]]; then idx=$i; break; fi
      done
      if [[ "$dir" == "prev" ]]; then
        next=$(( (idx - 1 + ''${#wins[@]}) % ''${#wins[@]} ))
      else
        next=$(( (idx + 1) % ''${#wins[@]} ))
      fi
      hyprctl dispatch focuswindow address:''${wins[$next]}
    '';
  };
}
