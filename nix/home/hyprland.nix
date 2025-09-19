{
  pkgs,
  hyprlandInput,
  hyprlandPluginsPkgs,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
    swappy
    xfce.thunar
    wlogout
    jq
    kdePackages.kwallet
    kdePackages.kwalletmanager
    wayvnc
  ];

  systemd.user.services.kwalletd6 = {
    Unit = {
      Description = "KWallet daemon (kwalletd6) for non-Plasma sessions";
      PartOf = ["hyprland-session.target"];
      After = ["graphical-session.target" "hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
  };

  systemd.user.services.wayvnc = {
    Unit = {
      Description = "WayVNC server for Hyprland";
      PartOf = ["hyprland-session.target"];
      After = ["graphical-session.target" "hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config %h/.config/wayvnc/config";
      Restart = "on-failure";
      RestartSec = 2;
      Environment = "XDG_RUNTIME_DIR=%t";
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = (builtins.getAttr pkgs.system hyprlandInput.packages).hyprland;
    plugins = [hyprlandPluginsPkgs.hyprexpo];
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$editor" = "kitty -e nvim";
      "$browser" = "firefox";

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        natural_scroll = 0;
        numlock_by_default = 1;
      };

      plugin.hyprexpo = {
        columns = 3;
        rows = 2;
        gap_size = 5;
        workspace_method = "center current";
        enable_gesture = true;
        gesture_fingers = 4;
        gesture_distance = 300;
        gesture_positive = true;
      };

      gestures = {
        gesture = "3, horizontal, workspace";
      };

      xwayland.force_zero_scaling = true;

      bind = [
        "ALT, TAB, exec, ~/.config/hypr/cycle_window.sh next"
        "ALT SHIFT, TAB, exec, ~/.config/hypr/cycle_window.sh prev"

        "$mainMod, Space, hyprexpo:expo, toggle"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Return, exec, $terminal"

        "$mainMod SHIFT, F, exec, $fileManager"
        "$mainMod SHIFT, E, exec, $editor"
        "$mainMod SHIFT, W, exec, $browser"

        "ALT, F1, exec, rofi -show window"
        "$mainMod, D, exec, rofi -show drun"
        "ALT, F3, exec, rofi -show run"

        "$mainMod, N, exec, nm-connection-editor"
        "$mainMod, P, exec, hyprpicker -a"
        "$mainMod, X, exec, wlogout"
        "$mainMod CTRL, X, exec, wlogout"
        "CTRL ALT, L, exec, hyprlock"

        "$mainMod, Q, killactive,"
        "CTRL ALT, Delete, exit,"
        "$mainMod, F, fullscreen,"
        "$mainMod, S, pseudo,"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        "$mainMod CTRL, left, resizeactive, -20 0"
        "$mainMod CTRL, right, resizeactive, 20 0"
        "$mainMod CTRL, up, resizeactive, 0 -20"
        "$mainMod CTRL, down, resizeactive, 0 20"

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

        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"

        ", Print, exec, grim - | wl-copy"
        "SUPER, Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "CTRL, Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        "$mainMod, mouse_up, resizeactive, 0 -20"
        "$mainMod, mouse_down, resizeactive, 0 20"
        "$mainMod SHIFT, mouse_up, resizeactive, 20 0"
        "$mainMod SHIFT, mouse_down, resizeactive, -20 0"
      ];

      exec-once = [
        "hyprpaper"
        "waybar"
      ];
    };
  };

  home.file.".config/hypr/cycle_window.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      dir="$1"
      ws=$(hyprctl activeworkspace -j | jq -r .id)
      mapfile -t wins < <(hyprctl clients -j | jq -r --argjson ws "$ws" '[.[] | select(.workspace.id == $ws and .mapped == true) | .address] | .[]')
      [ ''${#wins[@]} -le 1 ] && exit 0
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
  home.file.".config/wayvnc/config" = {
    text = ''
      # WayVNC config generated via Home Manager
      address=127.0.0.1
      enable_auth=true
      username=guacuser
      password=change-me
      # Optional: pick a fixed port (default 5900)
      # port=5900
    '';
  };
}
