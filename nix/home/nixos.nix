# Home-Manager Konfiguration für NixOS Systeme (Benutzer: ce)
{
  lib,
  pkgs,
  unstable,
  currentUser,
  userEmail,
  userFullName,
  hasPlasma,
  hostname,
  ...
}: {
  # Importiere deine bestehenden Module
  imports =
    [
      ./core.nix
      ./git.nix
      ./shell.nix
      ./starship.nix
      ./hyprland-dots-xdg.nix
      ./nwg-dock-hyprland.nix

      ./thunderbird.nix
      ./vscode.nix
      ./firefox.nix
    ]
    ++ lib.optionals (hostname != "offnix") [./kitty.nix];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home.username = currentUser;
  home.homeDirectory = "/home/${currentUser}";
  home.stateVersion = "25.05";

  # Fix ~/.smb_crd permissions

  home.activation.fixSmbCredsPerms =
    lib.mkIf (hostname == "offnix" || hostname == "devnix")
    (lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -f "$HOME/.smb_crd" ]; then
        chown "$USER":"$USER" "$HOME/.smb_crd" || true
        chmod 600 "$HOME/.smb_crd" || true
      fi
    '');

  # Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs.git = {
    userName = lib.mkForce userFullName; # Anpassen nach Bedarf
    userEmail = lib.mkForce userEmail; # Anpassen nach Bedarf
  };

  # Enable Hyprland-Dots XDG linking for offnix users (replaces stow-based approach)
  programs.hyprlandDotsXdg = lib.mkIf (hostname == "offnix") {
    enable = true;
    installRuntimePackages = true;
    excludeDirs = [ "nwg-dock-hyprland" ];
    # enableWayvnc disabled
    localIncludeContent = ''
      source = ~/.config/hypr/UserConfigs/AutoStart.conf
      source = ~/.config/hypr/UserConfigs/WindowRules.local.conf
      source = ~/.config/hypr/UserConfigs/Workspaces.local.conf
      source = ~/.config/hypr/UserConfigs/Keybinds.local.conf
    '';
  };

  programs.nwgDockHyprland = lib.mkIf (hostname == "offnix") {
    enable = true;
  };

  home.file.".config/hypr/UserConfigs/AutoStart.conf".text = ''
    exec-once = $HOME/.config/nwg-dock-hyprland/launch.sh
    exec-once = hyprctl dispatch renameworkspace 1 Dev
    exec-once = hyprctl dispatch renameworkspace 2 Web
    exec-once = hyprctl dispatch renameworkspace 3 Messenger
    exec-once = hyprctl dispatch renameworkspace 4 Mail
    exec-once = ~/.config/ml4w/scripts/sidepad.sh --init
    exec-once = ~/.config/ml4w/scripts/sidepad.sh --hide
  '';

  home.file.".config/hypr/UserConfigs/WindowRules.local.conf".text = ''
    # Example: route apps to specific workspaces (silent avoids focus jump)
    windowrulev2 = workspace 1 silent, class:^(code|codium|jetbrains-.*)$
    windowrulev2 = workspace 2 silent, class:^(firefox|librewolf|zen)$
    windowrulev2 = workspace 3 silent, class:^(vesktop|discord|Element)$

    # Ensure the sidebar window (ml4wsidebar) is floating
    windowrulev2 = float, class:^(Signal)$
  '';

  home.file.".config/hypr/UserConfigs/Workspaces.local.conf".text = ''
    # Example persistent workspaces bound to monitors
    # Find monitor names: hyprctl monitors
    workspace = 1, monitor:eDP-1, persistent:true
    workspace = 2, monitor:eDP-1, persistent:true
    # workspace = 3, monitor:HDMI-A-1, persistent:true
  '';

  # ml4w sidebar (Variant B) — sidepad scripts, pad, settings, keybinds
  home.file.".config/ml4w/scripts/sidepad.sh" = {
    text = ''
#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  /
# /___/_/\_,_/\__/ .__/\_,_/\_,_/
#               /_/
# Dispatcher

# Configuration
SIDEPAD_PATH="$HOME/.config/sidepad/sidepad"
SIDEPAD_DATA="$HOME/.config/ml4w/settings/sidepad-active"
SIDEPAD_PADS_FOLDER="$HOME/.config/sidepad/pads"
SIDEPAD_SELECT="$HOME/.config/sidepad/scripts/select.sh"

# Load active sidepad
SIDEPAD_OPTIONS=""
SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")
source $SIDEPAD_PADS_FOLDER/$(cat "$SIDEPAD_DATA")
source $SIDEPAD_PADS_FOLDER/$SIDEPAD_ACTIVE
echo ":: Current sidepad: $SIDEPAD_ACTIVE"
echo ":: Current sidepad app: $SIDEPAD_APP"
echo ":: Current sidepad class: $SIDEPAD_CLASS"

# Select new sidepad with rofi
select_sidepad() {
    # Open rofi
    pad=$(ls $SIDEPAD_PADS_FOLDER | rofi -dmenu -replace -i -config ~/.config/rofi/config-compact.rasi -no-show-icons -width 30 -p "Sidepads")

    # Set new sidepad
    if [ ! -z $pad ]; then
        echo ":: New sidepad: $pad"

        # Kill existing sidepad
        eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --kill"

        # Write pad into active data file
        echo "$pad" > "$SIDEPAD_DATA"
        SIDEPAD_ACTIVE=$(cat "$SIDEPAD_DATA")

        # Init sidepad
        source $SIDEPAD_PADS_FOLDER/$pad
        eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
        echo ":: Sidepad switched"
    fi
}

# Dispatch parameters
if [[ "$1" == "--init" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --init '$SIDEPAD_APP'"
elif [[ "$1" == "--hide" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --hide"
elif [[ "$1" == "--test" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --test"
elif [[ "$1" == "--kill" ]]; then
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' --kill"
elif [[ "$1" == "--select" ]]; then
    select_sidepad
else
    eval "$SIDEPAD_PATH --class '$SIDEPAD_CLASS' $SIDEPAD_OPTIONS"
fi
''; executable = true; };

  home.file.".config/sidepad/sidepad" = {
    text = ''
#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  /
# /___/_/\_,_/\__/ .__/\_,_/\_,_/
#               /_/
# Main Script

# --- Configuration ---
WINDOW_CLASS="dotfiles-sidepad"
HIDDEN_LEFT_GAP=10
VISIBLE_LEFT_GAP=10
TARGET_WIDTH=700
TARGET_WIDTH_MAX=1000
TOP_GAP=100
BOTTOM_GAP=100

# --- Script Variables ---
HIDE_REQUESTED=0

# --- Help Function ---
show_help() {
    echo "Usage: $0 [options]"
    echo "Please make sure that you're using the class only once."
    echo "The window must be in floating mode."
    echo ""
    echo "Options:"
    echo "  --class <name>         Override the window class (Default: $WINDOW_CLASS)"
    echo "  --hidden-gap <px>      Override the hidden left gap (Default: $HIDDEN_LEFT_GAP)"
    echo "  --visible-gap <px>     Override the visible left gap (Default: $VISIBLE_LEFT_GAP)"
    echo "  --width <px>           Override the target width (Default: $TARGET_WIDTH)"
    echo "  --width-max <px>       Override the maximum target width (Default: $TARGET_WIDTH_MAX)"
    echo "  --top-gap <px>         Override the top gap (Default: $TOP_GAP)"
    echo "  --bottom-gap <px>      Override the bottom gap (Default: $BOTTOM_GAP)"
    echo "  --hide                 Force the window to the hidden state."
    echo "  --kill                 Kills the running app with WINDOW_CLASS."
    echo "  --test                 Test for running app with WINDOW_CLASS."
    echo "  -h, --help             Display this help and exit"
    exit 0
}

test_sidepad() {
    if ! hyprctl clients -j | jq -e --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)' > /dev/null; then
        echo "1"
        return 1
    else
        echo "0"
        return 0
    fi
}

init_sidepad() {
    # Check if the window already exists, if not launch it
    if ! hyprctl clients -j | jq -e --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)' > /dev/null; then
        if [[ "$WINDOW_CLASS" == "dotfiles-sidepad" ]]; then
            eval "$1 --class $WINDOW_CLASS" &
        else
            eval "$1" &
        fi
        # Wait for the window to appear, with a timeout
        for i in {1..50}; do # ~2 seconds timeout
            if hyprctl clients -j | jq -e --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)' > /dev/null; then
                break
            fi
            sleep 0.1
        done
    fi
}

kill_sidepad() {
    WINDOW_PID=$(hyprctl clients -j | jq -r --arg class "$WINDOW_CLASS" '.[] | select(.class == $class) | .pid')
    if [ -n "$WINDOW_PID" ] && [ "$WINDOW_PID" -ne -1 ]; then
        echo "Killing process with PID $WINDOW_PID for window class '$WINDOW_CLASS'."
        kill "$WINDOW_PID"
    else
        echo "Error: Window with class '$WINDOW_CLASS' not found or has no valid PID." >&2
    fi
    sleep 1
    exit 0
}

# --- Parse Command-line Options ---
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --class)
            WINDOW_CLASS="$2"
            shift; shift
        ;;

        --hidden-gap)
            HIDDEN_LEFT_GAP="$2"
            shift; shift
        ;;

        --visible-gap)
            VISIBLE_LEFT_GAP="$2"
            shift; shift
        ;;

        --width)
            TARGET_WIDTH="$2"
            shift; shift
        ;;

        --width-max)
            TARGET_WIDTH_MAX="$2"
            shift; shift
        ;;

        --top-gap)
            TOP_GAP="$2"
            shift; shift
        ;;

        --bottom-gap)
            BOTTOM_GAP="$2"
            shift; shift
        ;;

        --hide)
            HIDE_REQUESTED=1
            shift
        ;;

        --test)
            test_sidepad
            exit 0
        ;;

        --kill)
            kill_sidepad
        ;;

        --init)
            SIDEPAD_APP="$2"
            init_sidepad "$SIDEPAD_APP"
            HIDE_REQUESTED=1
            shift 2
        ;;

        -h|--help)
            show_help
        ;;

        *)
            # unknown option
            shift
        ;;
    esac
done

# --- Get Window and Monitor Info ---
WINDOW_INFO=$(hyprctl clients -j | jq --arg class "$WINDOW_CLASS" '.[] | select(.class == $class)')
MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')

if [ -z "$WINDOW_INFO" ]; then
    echo "Error: Window with class '$WINDOW_CLASS' not found. Is the window open?"
    exit 1
fi

WINDOW_ADDRESS=$(echo "$WINDOW_INFO" | jq -r '.address')
WINDOW_WIDTH=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | jq -r '.size[1]')
WINDOW_X=$(echo "$WINDOW_INFO" | jq -r '.at[0]')
WINDOW_Y=$(echo "$WINDOW_INFO" | jq -r '.at[1]')
MONITOR_HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')

# --- Main Logic ---

# Case 1: --hide flag is used, unconditionally hide the window.
if [[ "$HIDE_REQUESTED" -eq 1 ]]; then
    if (( WINDOW_X >= 0 )); then # Only act if it is not already hidden
        echo "--- Hiding window (--hide) ---"
        PIXELS_TO_MOVE_X=$(( (WINDOW_X * -1) - TARGET_WIDTH + HIDDEN_LEFT_GAP ))
        WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
        PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
        TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
        HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))

        hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
        echo "Operation completed."
    else
        echo "Window is already hidden."
    fi
    exit 0
fi

# Case 2: Window is hidden, so show it.
if (( WINDOW_X < 0 )); then
    echo "--- Showing window ---"
    PIXELS_TO_MOVE_X=$(( VISIBLE_LEFT_GAP - WINDOW_X ))
    WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
    PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
    TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))

    hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."

# Case 3: Window is visible, so toggle its width and correct its position.
else
    # Ensure vertical position and height are correct
    PIXELS_TO_MOVE_Y=$(( TOP_GAP - WINDOW_Y ))
    TARGET_HEIGHT=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    HEIGHT_CHANGE=$(( TARGET_HEIGHT - WINDOW_HEIGHT ))

    # Don't move horizontally
    PIXELS_TO_MOVE_X=0

    # Calculate width change
    if (( WINDOW_WIDTH == TARGET_WIDTH )); then
        echo "--- Expanding width to max ---"
        WIDTH_CHANGE=$(( TARGET_WIDTH_MAX - WINDOW_WIDTH ))
    else
        echo "--- Shrinking width to default ---"
        WIDTH_CHANGE=$(( TARGET_WIDTH - WINDOW_WIDTH ))
    fi

    hyprctl --batch "dispatch resizewindowpixel $WIDTH_CHANGE $HEIGHT_CHANGE,address:$WINDOW_ADDRESS; dispatch movewindowpixel $PIXELS_TO_MOVE_X $PIXELS_TO_MOVE_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."
fi
''; executable = true; };

  home.file.".config/sidepad/pads/signal".text = ''
    # Sidepad pad for Signal
    SIDEPAD_APP="signal-desktop --pasword-store=kwallet6"
    SIDEPAD_CLASS="Signal"
    SIDEPAD_OPTIONS=""
  '';

  home.file.".config/ml4w/settings/sidepad-active".text = ''
    signal
  '';

  home.file.".config/hypr/UserConfigs/Keybinds.local.conf".text = ''
    # Toggle sidebar
    bind = $mainMod, S, exec, ~/.config/ml4w/scripts/sidepad.sh
    # Select pad (rofi)
    bind = $mainMod, Shift+S, exec, ~/.config/ml4w/scripts/sidepad.sh --select
  '';

  # programs.rofi = lib.mkIf (hostname != "offnix") {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  #   terminal = "kitty";
  #   theme = "~/.config/rofi/themes/catppuccin-mocha.rasi";
  #   extraConfig = {
  #     modi = "drun,run,window";
  #     show-icons = true;
  #     icon-theme = "Papirus-Dark";
  #     drun-display-format = "{icon} {name}";
  #     display-drun = "Apps";
  #     display-run = "Run";
  #     display-window = "Windows";
  #   };
  # };

  # Plasma-spezifische Konfiguration nur für Systeme mit KDE
  programs.plasma = lib.mkIf hasPlasma {
    enable = true;

    # Desktop-Einstellungen
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      iconTheme = "breeze-dark";
      cursor.theme = "breeze_cursors";
    };
    kwin.scripts.polonium.enable = false;
    input = {
      keyboard = {
        layouts = [{
          displayName = "US intl";
          layout = "us";
          variant = "intl";
        }];
      };
      touchpads = [
        {
          enable = true;
          name = "Apple Inc. Apple Internal Keyboard / Trackpad";
          vendorId = "05ac"; # Apple Vendor ID
          productId = "0263"; # Dein MacBook Trackpad
          naturalScroll = true; # Traditionelles Scrolling!
          tapToClick = true;
          rightClickMethod = "twoFingers";
        }
      ];
    };
    # Panel-Konfiguration
    panels = [
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Shortcuts
    shortcuts = {
      ksmserver = { "Lock Session" = [ "Screensaver" "Meta+L" ]; };
      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
      };
    };
  };

  # Zusätzliche NixOS-spezifische Pakete
  home.packages =
    (with pkgs; [
      # Browser (falls nicht system-weit installiert)
      ags
      ansible
      ansible-lint
      discord
      fzf
      git-crypt
      openssl
      glow
      pgadmin4
      remmina
      texlive.combined.scheme-small
      md2pdf
      pandoc
      signal-desktop
      teamviewer
      waybar
      nwg-drawer
      inetutils
      unstable.zed-editor
    ])
    ++ lib.optionals (hostname == "offnix") [ pkgs.kitty ];
  services.kdeconnect.enable = true;
  services.ssh-agent.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-curses; # QT-Version für KDE
    defaultCacheTtl = 28800; # 8 Stunden
    maxCacheTtl = 86400; # 24 Stunden
  };
}
