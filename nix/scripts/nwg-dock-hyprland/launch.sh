#!/usr/bin/env bash
#  _   _ _       _            _            _             _             _
# | \ | (_) __ _| | _____  __| | ___  _ __| | ___   __ _(_)_ __   __ _| |
# |  \| | |/ _` | |/ / _ \/ _` |/ _ \| '__| |/ _ \ / _` | | '_ \ / _` | |
# | |\  | | (_| |   <  __/ (_| | (_) | |  | | (_) | (_| | | | | | (_| | |
# |_| \_|_|\__,_|_|\_\___|\__,_|\___/|_|  |_|\___/ \__, |_|_| |_|\__,_|_|
#                                                 |___/
#
# nwg-dock-hyprland — launcher
#
# This script is intended to be called from your session autostart.
# It safely (re)starts nwg-dock-hyprland using your ~/.config/nwg-dock-hyprland/style.css
# and an app launcher (rofi) if available.
#
# Behavior can be customized via environment variables:
#   NWG_DOCK_ICON_SIZE     default: 32
#   NWG_DOCK_WORKSPACES    default: 5
#   NWG_DOCK_MARGIN_BOTTOM default: 10
#   NWG_DOCK_STYLE         default: $XDG_CONFIG_HOME/nwg-dock-hyprland/style.css
#   NWG_DOCK_LAUNCHER_CMD  default: "rofi -show drun" (omitted if rofi not found)
#
# To disable the dock (e.g., per-user toggle), create:
#   ~/.config/ml4w/settings/dock-disabled
#
# Exit codes:
#   0 on success (or if disabled), non-zero on unexpected errors.

set -euo pipefail

# Paths
XDG_CONF_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONF_DIR="$XDG_CONF_HOME/nwg-dock-hyprland"
DISABLE_FLAG="$HOME/.config/ml4w/settings/dock-disabled"

# Respect user toggle
if [[ -f "$DISABLE_FLAG" ]]; then
  echo ":: Dock disabled (flag present: $DISABLE_FLAG)"
  exit 0
fi

# Ensure nwg-dock-hyprland is available
if ! command -v nwg-dock-hyprland >/dev/null 2>&1; then
  echo "Error: nwg-dock-hyprland not found in PATH" >&2
  exit 1
fi

# Build arguments
ICON_SIZE="${NWG_DOCK_ICON_SIZE:-32}"
WORKSPACES="${NWG_DOCK_WORKSPACES:-5}"
MARGIN_BOTTOM="${NWG_DOCK_MARGIN_BOTTOM:-10}"

STYLE_PATH_DEFAULT="$CONF_DIR/style.css"
STYLE_PATH="${NWG_DOCK_STYLE:-$STYLE_PATH_DEFAULT}"

# Compose argument array
ARGS=( -i "$ICON_SIZE" -w "$WORKSPACES" -mb "$MARGIN_BOTTOM" -x )

# Add style if present
if [[ -f "$STYLE_PATH" ]]; then
  ARGS+=( -s "$STYLE_PATH" )
else
  # If a custom style was specified but not found, warn; otherwise run without -s
  if [[ "${NWG_DOCK_STYLE:-}" != "" ]]; then
    echo "Warning: NWG_DOCK_STYLE points to missing file: $STYLE_PATH" >&2
  fi
fi

# Launcher command (-c)
LAUNCHER_CMD_DEFAULT="rofi -show drun"
LAUNCHER_CMD="${NWG_DOCK_LAUNCHER_CMD:-$LAUNCHER_CMD_DEFAULT}"

if [[ "$LAUNCHER_CMD" == "$LAUNCHER_CMD_DEFAULT" ]]; then
  if command -v rofi >/dev/null 2>&1; then
    ARGS+=( -c "$LAUNCHER_CMD" )
  else
    echo "Note: rofi not found; starting dock without -c launcher"
  fi
elif [[ -n "$LAUNCHER_CMD" ]]; then
  ARGS+=( -c "$LAUNCHER_CMD" )
fi

# Stop any previous instance
pkill -x nwg-dock-hyprland >/dev/null 2>&1 || true
sleep 0.5

# Launch
exec nwg-dock-hyprland "${ARGS[@]}"
