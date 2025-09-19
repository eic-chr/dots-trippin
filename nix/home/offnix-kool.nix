{
  config,
  lib,
  pkgs,
  hyprlandPluginsPkgs,
  ...
}:
# Home-Manager profile variant for offnix users:
# - Does NOT import ./kool-dots.nix; use stow-managed Dots instead
# - Explicitly disables the local HM Hyprland module to avoid conflicts
#
# Usage:
# - Import this module for users on the offnix host instead of (or in addition to) your default HM profile.
# - Ensure your flake passes `hyprlandDots = inputs.hyprland-dots` via specialArgs (flake.nix already adjusted).
#
# Notes:
# - This variant relies on system-level Hyprland (nixosPrograms.hyprland) from hosts/hyprland.nix.
# - Rofi HM module is disabled; the Dots provide their own rofi configs.
# - If you still import ./hyprland.nix elsewhere, this will override its HM Hyprland enable flag.
{
  # No imports here; KooL Hyprland-Dots are managed via stow

  # Disable the Home-Manager Hyprland module to avoid config collisions with KooL-Dots
  wayland.windowManager.hyprland.enable = lib.mkForce false;
  home.sessionVariables.HYPRLAND_PLUGINS = "${hyprlandPluginsPkgs.hyprexpo}/lib/libhyprexpo.so";

  # Optional: disable HM rofi module since Dots ship their own rofi configs
  programs.rofi.enable = lib.mkForce false;

  home.packages = with pkgs; [
    wayvnc
    xfce.thunar
  ];

  systemd.user.services.wayvnc = {
    Unit = {
      Description = "WayVNC server for Wayland/Hyprland";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config %h/.config/wayvnc/config";
      Restart = "on-failure";
      RestartSec = 2;
      Environment = "XDG_RUNTIME_DIR=%t";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  home.file.".config/wayvnc/config" = {
    text = ''
      address=0.0.0.0
      enable_auth=false
      username=guacuser
      password=change-me
      # port=5900
    '';
  };

  # Optional safety assertion (uncomment if you prefer hard failure over mkForce override)
  # assertions = [
  #   {
  #     assertion = !(config.wayland.windowManager.hyprland.enable or false);
  #     message = "offnix-kool.nix: Disable HM Hyprland when using KooL's Hyprland-Dots.";
  #   }
  # ];
  # Local Hyprland overrides for offnix (loaded after KooL's hyprland.conf)
  home.file.".config/hypr/zz-local.conf".text = ''

    # Hyprexpo: 4-Finger-Geste; Hyprland Workspace-Swipe bleibt auf 3 Fingern
    plugin = ${hyprlandPluginsPkgs.hyprexpo}/lib/libhyprexpo.so
    plugin {
      hyprexpo {
        enable_gesture = true
        gesture_fingers = 4
        gesture_distance = 300
        gesture_positive = true
        columns = 3
        rows = 2
        gap_size = 5
        workspace_method = "center current"
      }
    }
    #
    gestures {
      gesture = 3, horizontal, workspace
      workspace_swipe_distance = 300
    }
    source = ~/.config/hypr/workspace-rules.conf
    exec-once = ~/.config/hypr/scripts/assign_workspaces.sh

    ### --- AUTOSTART --- ###
    exec-once = [workspace 2 silent] firefox
    exec-once = [workspace 3 silent] kwallet6
    exec-once = [workspace 3 silent] keepassxc
    exec-once = [workspace 1 silent] thunderbird
    exec-once = [workspace 7 silent] signal-desktop --password-store=kwallet6
    exec-once = [workspace 1 silent] nextcloud

    $mainMod = SUPER
    $terminal = kitty
    $fileManager = thunar
    $editor = kitty -e nvim
    $browser = firefox

    # bind = $mainMod, Return, exec, $terminal
    # bind = $mainMod SHIFT, F, exec, $fileManager
    # bind = $mainMod SHIFT, E, exec, $editor
    # bind = $mainMod SHIFT, W, exec, $browser
    #
    # bind = ALT, F1, exec, rofi -show window
    # bind = $mainMod, D, exec, rofi -show drun
    # bind = ALT, F3, exec, rofi -show run
    #
    # bind = $mainMod, Q, killactive,
    # bind = $mainMod, F, fullscreen,
    # bind = $mainMod, S, pseudo,
    #
    # bind = $mainMod, left, movefocus, l
    # bind = $mainMod, right, movefocus, r
    # bind = $mainMod, up, movefocus, u
    # bind = $mainMod, down, movefocus, d
    #
    # bind = $mainMod SHIFT, left, movewindow, l
    # bind = $mainMod SHIFT, right, movewindow, r
    # bind = $mainMod SHIFT, up, movewindow, u
    # bind = $mainMod SHIFT, down, movewindow, d
    #
    # bind = $mainMod, 1, workspace, 1
    # bind = $mainMod, 2, workspace, 2
    # bind = $mainMod, 3, workspace, 3
    # bind = $mainMod, 4, workspace, 4
    # bind = $mainMod, 5, workspace, 5
    # bind = $mainMod, 6, workspace, 6
    # bind = $mainMod, 7, workspace, 7
    # bind = $mainMod, 8, workspace, 8
    # bind = $mainMod, 9, workspace, 9
    # bind = $mainMod, 0, workspace, 10
    #
    # bind = ALT, 1, movetoworkspace, 1
    # bind = ALT, 2, movetoworkspace, 2
    # bind = ALT, 3, movetoworkspace, 3
    # bind = ALT, 4, movetoworkspace, 4
    # bind = ALT, 5, movetoworkspace, 5
    # bind = ALT, 6, movetoworkspace, 6
    # bind = ALT, 7, movetoworkspace, 7
    # bind = ALT, 8, movetoworkspace, 8
    # bind = ALT, 9, movetoworkspace, 9
    # bind = ALT, 0, movetoworkspace, 10
    #
    bind = $mainMod, Space, hyprexpo:expo, toggle
    bind = $mainMod SHIFT, Space, togglefloating,
    #
    # bind = ALT, TAB, exec, ~/.config/hypr/cycle_window.sh next
    # bind = ALT SHIFT, TAB, exec, ~/.config/hypr/cycle_window.sh prev
    #
    # bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    # bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
    # bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    # bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    # bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    # bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    # bind = , XF86AudioNext, exec, playerctl next
    # bind = , XF86AudioPrev, exec, playerctl previous
    # bind = , XF86AudioPlay, exec, playerctl play-pause
    # bind = , XF86AudioStop, exec, playerctl stop
    #
    # bind = , Print, exec, grim - | wl-copy
    # bind = SUPER, Print, exec, grim -g "$(slurp)" - | wl-copy
    # bind = CTRL, Print, exec, grim -g "$(slurp)" - | swappy -f -
    #
    # bindm = $mainMod, mouse:272, movewindow
    # bindm = $mainMod, mouse:273, resizewindow
    #
    # binde = $mainMod, mouse_up, resizeactive, 0 -20
    # binde = $mainMod, mouse_down, resizeactive, 0 20
    # binde = $mainMod SHIFT, mouse_up, resizeactive, 20 0
    # binde = $mainMod SHIFT, mouse_down, resizeactive, -20 0
  '';

  home.file.".config/hypr/scripts/assign_workspaces.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      OUT="$HOME/.config/hypr/workspace-rules.conf"
      mkdir -p "$HOME/.config/hypr"

      # Wait for monitors to be available (up to ~5s)
      attempts=50
      delay=0.1
      MONS=()
      for _ in $(seq 1 "$attempts"); do
        MONS_JSON="$(hyprctl -j monitors || echo '[]')"
        mapfile -t MONS < <(printf '%s\n' "$MONS_JSON" | jq -r '.[] | select(.disabled==false) | .name')
        if [ ''${#MONS[@]} -gt 0 ]; then
          break
        fi
        sleep "$delay"
      done

      # If still no monitors, do nothing
      if [ ''${#MONS[@]} -eq 0 ]; then
        exit 0
      fi

      M1="''${MONS[0]}"
      M2="''${MONS[1]:-''${MONS[0]}}"

      tmpdir="$(dirname "$OUT")"
      TMP="$(mktemp "$tmpdir/.workspace-rules.conf.XXXXXXXX")"

      {
        for ws in 1 2 3 4; do
          echo "workspace = $ws, monitor:$M1"
        done
        for ws in 5 6 7 8 9; do
          echo "workspace = $ws, monitor:$M2"
        done
      } > "$TMP"

      changed=1
      if [ -f "$OUT" ] && cmp -s "$TMP" "$OUT"; then
        changed=0
      fi

      if [ "$changed" -eq 1 ]; then
        mv -f "$TMP" "$OUT"
      else
        rm -f "$TMP"
      fi

      # Reload Hyprland only if rules changed
      if [ "$changed" -eq 1 ]; then
        hyprctl reload >/dev/null 2>&1 || true
      fi
    '';
  };

  # Ensure workspace-rules.conf exists to avoid include failure before script populates it
  home.file.".config/hypr/workspace-rules.conf" = {
    text = "";
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

  home.activation.hyprLocalInclude = lib.hm.dag.entryAfter ["writeBoundary"] ''
    conf="$HOME/.config/hypr/hyprland.conf"
    include="source = ~/.config/hypr/zz-local.conf"
    mkdir -p "$HOME/.config/hypr"
    if [ -f "$conf" ] && ! grep -qF "$include" "$conf"; then
      printf "\n# Local overrides (added by Home Manager)\n%s\n" "$include" >> "$conf"
    fi
  '';
}
