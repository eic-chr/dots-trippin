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
VISIBLE_LEFT_GAP=40
TARGET_WIDTH=700
TARGET_WIDTH_MAX=1000
TOP_GAP=100
BOTTOM_GAP=100
# Max height percentage (center vertically)
HEIGHT_PERCENT=75
# Extra pixels to push off-screen when hiding (avoid 1-2px sliver)
HIDE_EXTRA=8

# --- Script Variables ---
HIDE_REQUESTED=0
EXPAND_REQUESTED=0

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
        --expand)
            EXPAND_REQUESTED=1
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
MONITORS_JSON="$(hyprctl monitors -j)"
MONITOR_ID="$(echo "$WINDOW_INFO" | jq -r '.monitor // empty')"
# Try resolving by monitor id
MONITOR_INFO="$(echo "$MONITORS_JSON" | jq -r --arg id "$MONITOR_ID" 'first(.[] | select((.id|tostring) == $id)) // empty')"
# Fallback: resolve by the window's workspace id -> activeWorkspace.id
if [ -z "$MONITOR_INFO" ]; then
  WS_ID="$(echo "$WINDOW_INFO" | jq -r '.workspace.id // empty')"
  if [ -n "$WS_ID" ]; then
    MONITOR_INFO="$(echo "$MONITORS_JSON" | jq -r --argjson ws "$WS_ID" 'first(.[] | select(.activeWorkspace.id == $ws)) // empty')"
  fi
fi
# Fallback: resolve by the window's workspace name -> activeWorkspace.name
if [ -z "$MONITOR_INFO" ]; then
  WS_NAME="$(echo "$WINDOW_INFO" | jq -r '.workspace.name // empty')"
  if [ -n "$WS_NAME" ]; then
    MONITOR_INFO="$(echo "$MONITORS_JSON" | jq -r --arg ws "$WS_NAME" 'first(.[] | select(.activeWorkspace.name == $ws)) // empty')"
  fi
fi
# Final fallback: focused monitor
if [ -z "$MONITOR_INFO" ] || [ "$MONITOR_INFO" = "null" ]; then
  MONITOR_INFO="$(echo "$MONITORS_JSON" | jq -r 'first(.[] | select(.focused == true)) // empty')"
fi
if [ -z "$MONITOR_INFO" ] || [ "$MONITOR_INFO" = "null" ]; then
  echo "Error: Could not resolve monitor for sidepad window." >&2
  exit 1
fi

if [ -z "$WINDOW_INFO" ]; then
    echo "Error: Window with class '$WINDOW_CLASS' not found. Is the window open?"
    exit 1
fi

WINDOW_ADDRESS=$(echo "$WINDOW_INFO" | jq -r '.address')
WINDOW_WIDTH=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | jq -r '.size[1]')
WINDOW_X=$(echo "$WINDOW_INFO" | jq -r '.at[0]')
WINDOW_Y=$(echo "$WINDOW_INFO" | jq -r '.at[1]')
MONITOR_X=$(echo "$MONITOR_INFO" | jq -r '.x')
MONITOR_Y=$(echo "$MONITOR_INFO" | jq -r '.y')
MONITOR_HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')

# --- Main Logic ---

# Explicit expand: toggle width while staying visible
if [[ "$EXPAND_REQUESTED" -eq 1 ]]; then
    # Compute centered height with percentage cap
    MAX_H=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    VIS_H=$(( MONITOR_HEIGHT * HEIGHT_PERCENT / 100 ))
    if (( VIS_H > MAX_H )); then DESIRED_H=$MAX_H; else DESIRED_H=$VIS_H; fi
    DESIRED_Y=$(( MONITOR_Y + (MONITOR_HEIGHT - DESIRED_H) / 2 ))
    DESIRED_X=$(( MONITOR_X + VISIBLE_LEFT_GAP ))
    if (( WINDOW_WIDTH == TARGET_WIDTH )); then
        DESIRED_W=$(( TARGET_WIDTH_MAX ))
    else
        DESIRED_W=$(( TARGET_WIDTH ))
    fi
    hyprctl --batch "dispatch resizewindowpixel exact $DESIRED_W $DESIRED_H,address:$WINDOW_ADDRESS; dispatch movewindowpixel exact $DESIRED_X $DESIRED_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."
    exit 0
fi

# Case 1: --hide flag is used, unconditionally hide the window.
if [[ "$HIDE_REQUESTED" -eq 1 ]]; then
    if (( WINDOW_X >= MONITOR_X )); then # Only act if it is not already hidden
        echo "--- Hiding window (--hide) ---"
        # Compute centered height with percentage cap
        MAX_H=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
        VIS_H=$(( MONITOR_HEIGHT * HEIGHT_PERCENT / 100 ))
        if (( VIS_H > MAX_H )); then DESIRED_H=$MAX_H; else DESIRED_H=$VIS_H; fi
        DESIRED_Y=$(( MONITOR_Y + (MONITOR_HEIGHT - DESIRED_H) / 2 ))
        DESIRED_X=$(( MONITOR_X + HIDDEN_LEFT_GAP - TARGET_WIDTH - HIDE_EXTRA ))
        DESIRED_W=$(( TARGET_WIDTH ))

        hyprctl --batch "dispatch resizewindowpixel exact $DESIRED_W $DESIRED_H,address:$WINDOW_ADDRESS; dispatch movewindowpixel exact $DESIRED_X $DESIRED_Y,address:$WINDOW_ADDRESS"
        echo "Operation completed."
    else
        echo "Window is already hidden."
    fi
    exit 0
fi

# Case 2: Window is hidden, so show it.
if (( WINDOW_X < MONITOR_X )); then
    echo "--- Showing window ---"
    # Compute centered height with percentage cap
    MAX_H=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    VIS_H=$(( MONITOR_HEIGHT * HEIGHT_PERCENT / 100 ))
    if (( VIS_H > MAX_H )); then DESIRED_H=$MAX_H; else DESIRED_H=$VIS_H; fi
    DESIRED_Y=$(( MONITOR_Y + (MONITOR_HEIGHT - DESIRED_H) / 2 ))
    DESIRED_X=$(( MONITOR_X + VISIBLE_LEFT_GAP ))
    DESIRED_W=$(( TARGET_WIDTH ))

    hyprctl --batch "dispatch resizewindowpixel exact $DESIRED_W $DESIRED_H,address:$WINDOW_ADDRESS; dispatch movewindowpixel exact $DESIRED_X $DESIRED_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."

# Case 3: Window is visible, so toggle its width and correct its position.
else
    echo "--- Toggle: hide ---"
    # Compute centered height with percentage cap
    MAX_H=$(( MONITOR_HEIGHT - TOP_GAP - BOTTOM_GAP ))
    VIS_H=$(( MONITOR_HEIGHT * HEIGHT_PERCENT / 100 ))
    if (( VIS_H > MAX_H )); then DESIRED_H=$MAX_H; else DESIRED_H=$VIS_H; fi
    DESIRED_Y=$(( MONITOR_Y + (MONITOR_HEIGHT - DESIRED_H) / 2 ))
    DESIRED_X=$(( MONITOR_X + HIDDEN_LEFT_GAP - TARGET_WIDTH - HIDE_EXTRA ))
    DESIRED_W=$(( TARGET_WIDTH ))
    hyprctl --batch "dispatch resizewindowpixel exact $DESIRED_W $DESIRED_H,address:$WINDOW_ADDRESS; dispatch movewindowpixel exact $DESIRED_X $DESIRED_Y,address:$WINDOW_ADDRESS"
    echo "Operation completed."
fi
