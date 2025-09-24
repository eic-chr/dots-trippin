#!/usr/bin/env bash
#    _____    __                 __
#   / __(_)__/ /__ ___  ___ ____/ /
#  _\ \/ / _  / -_) _ \/ _ `/ _  /
# /___/_/\_,_/\__/ .__/\_,_/\_,_/
#               /_/
# ml4w Sidepad — Dispatcher
#
# This script dispatches actions to the sidepad controller script and manages
# the active "pad" (app/class/options) selection.
#
# Defaults expect:
#   - Controller script at:  ~/.config/sidepad/sidepad
#   - Active pad marker at:  ~/.config/ml4w/settings/sidepad-active
#   - Pad definitions under: ~/.config/sidepad/pads/<padname>
#
# A pad file should set:
#   SIDEPAD_APP="command to run your app"
#   SIDEPAD_CLASS="WindowClassName"
#   SIDEPAD_OPTIONS="optional args for sidepad controller"
#
# Usage examples:
#   sidepad-dispatcher.sh --init
#   sidepad-dispatcher.sh --hide
#   sidepad-dispatcher.sh --select
#   sidepad-dispatcher.sh               # default toggle
#
# Optional environment overrides:
#   SIDEPAD_PATH, SIDEPAD_DATA, SIDEPAD_PADS_FOLDER, SIDEPAD_SELECT_CMD

set -euo pipefail

# --- Configuration (defaults) ---
SIDEPAD_PATH="${SIDEPAD_PATH:-$HOME/.config/sidepad/sidepad}"
SIDEPAD_DATA="${SIDEPAD_DATA:-$HOME/.config/ml4w/settings/sidepad-active}"
SIDEPAD_PADS_FOLDER="${SIDEPAD_PADS_FOLDER:-$HOME/.config/sidepad/pads}"
# Default rofi selection command; can be overridden via SIDEPAD_SELECT_CMD
SIDEPAD_SELECT_CMD="${SIDEPAD_SELECT_CMD:-rofi -dmenu -replace -i -config \"$HOME/.config/rofi/config-compact.rasi\" -no-show-icons -width 30 -p \"Sidepads\"}"

# --- Sanity checks ---
require_file() {
  local f="$1"
  local why="${2:-file required}"
  if [[ ! -f "$f" ]]; then
    echo "Error: $why ($f not found)" >&2
    exit 1
  fi
}

require_exe() {
  local exe="$1"
  if ! command -v "$exe" >/dev/null 2>&1; then
    echo "Error: required command '$exe' not found in PATH" >&2
    exit 1
  fi
}

# --- Load active pad (with graceful defaults) ---
load_active_pad() {
  # Ensure pads folder exists
  if [[ ! -d "$SIDEPAD_PADS_FOLDER" ]]; then
    echo "Error: Pads folder not found: $SIDEPAD_PADS_FOLDER" >&2
    exit 1
  fi

  # If no active file, initialize with the first pad in folder (alphabetically)
  if [[ ! -f "$SIDEPAD_DATA" ]]; then
    local first
    first="$(ls -1 "$SIDEPAD_PADS_FOLDER" 2>/dev/null | head -n1 || true)"
    if [[ -z "${first:-}" ]]; then
      echo "Error: No pads found in $SIDEPAD_PADS_FOLDER" >&2
      exit 1
    fi
    mkdir -p "$(dirname "$SIDEPAD_DATA")"
    echo "$first" > "$SIDEPAD_DATA"
  fi

  SIDEPAD_ACTIVE="$(cat "$SIDEPAD_DATA")"
  local padfile="$SIDEPAD_PADS_FOLDER/$SIDEPAD_ACTIVE"
  if [[ ! -f "$padfile" ]]; then
    echo "Error: Active pad file not found: $padfile" >&2
    exit 1
  fi

  # Reset and source pad variables
  SIDEPAD_APP=""
  SIDEPAD_CLASS=""
  SIDEPAD_OPTIONS=""

  # shellcheck disable=SC1090
  source "$padfile"

  if [[ -z "${SIDEPAD_APP:-}" || -z "${SIDEPAD_CLASS:-}" ]]; then
    echo "Error: Pad '$SIDEPAD_ACTIVE' must set SIDEPAD_APP and SIDEPAD_CLASS" >&2
    exit 1
  fi

  echo ":: Current sidepad: $SIDEPAD_ACTIVE"
  echo ":: Current sidepad app: $SIDEPAD_APP"
  echo ":: Current sidepad class: $SIDEPAD_CLASS"
}

# --- Selection UI (rofi) ---
select_sidepad() {
  require_exe rofi

  # shellcheck disable=SC2086
  local pad
  pad="$(ls -1 "$SIDEPAD_PADS_FOLDER" | eval "$SIDEPAD_SELECT_CMD")" || true

  if [[ -n "${pad:-}" ]]; then
    echo ":: New sidepad: $pad"

    # Kill existing sidepad for the current class
    "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --kill || true

    # Switch active
    echo "$pad" > "$SIDEPAD_DATA"
    SIDEPAD_ACTIVE="$pad"

    # Load new pad
    # shellcheck disable=SC1090
    source "$SIDEPAD_PADS_FOLDER/$pad"
    if [[ -z "${SIDEPAD_APP:-}" || -z "${SIDEPAD_CLASS:-}" ]]; then
      echo "Error: Selected pad '$pad' missing SIDEPAD_APP or SIDEPAD_CLASS" >&2
      exit 1
    fi

    # Initialize the sidepad with the new app
    "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --init "$SIDEPAD_APP"
    echo ":: Sidepad switched"
  else
    echo ":: Selection cancelled"
  fi
}

# --- Argument parsing ---
ACTION="${1:-toggle}"

case "${ACTION}" in
  --help|-h|help)
    cat <<'EOF'
ml4w Sidepad — Dispatcher

Usage:
  sidepad-dispatcher.sh [--init|--hide|--kill|--test|--select]
  sidepad-dispatcher.sh            # default toggle

Actions:
  --init     Initialize the current active pad (launch app and hide)
  --hide     Force hide the sidepad window
  --kill     Kill the sidepad window (by class)
  --test     Test presence of sidepad window (exit 0 if found, 1 otherwise)
  --select   Choose a different pad via rofi
EOF
    exit 0
    ;;
  --init|--hide|--kill|--test|--select)
    shift || true
    ;;
  *)
    # Default action is toggle (no additional shift)
    ACTION="toggle"
    ;;
esac

# --- Main dispatch ---
require_file "$SIDEPAD_PATH" "sidepad controller script"
load_active_pad

case "$ACTION" in
  toggle)
    # Default toggle: show/hide
    exec "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" ${SIDEPAD_OPTIONS:-}
    ;;
  --init)
    exec "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --init "$SIDEPAD_APP"
    ;;
  --hide)
    exec "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --hide
    ;;
  --kill)
    exec "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --kill
    ;;
  --test)
    exec "$SIDEPAD_PATH" --class "$SIDEPAD_CLASS" --test
    ;;
  --select)
    select_sidepad
    ;;
  *)
    echo "Error: Unknown action '$ACTION'" >&2
    exit 1
    ;;
esac
