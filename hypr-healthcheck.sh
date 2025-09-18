#!/usr/bin/env bash
# hypr-healthcheck.sh
# Prüft, ob KooL/JaKooLit Hyprland-Dots korrekt verlinkt sind und ob Styles/Assets/Runtime-Tools vorhanden sind.

set -euo pipefail

# ------------- UI helpers -------------
if command -v tput >/dev/null 2>&1; then
  GREEN="$(tput setaf 2)"; RED="$(tput setaf 1)"; YELLOW="$(tput setaf 3)"; BLUE="$(tput setaf 4)"; DIM="$(tput dim)"; BOLD="$(tput bold)"; RESET="$(tput sgr0)"
else
  GREEN=""; RED=""; YELLOW=""; BLUE=""; DIM=""; BOLD=""; RESET=""
fi

ok()   { printf "%s[OK]%s %s\n"   "$GREEN" "$RESET" "$*"; }
warn() { printf "%s[WARN]%s %s\n" "$YELLOW" "$RESET" "$*"; }
err()  { printf "%s[ERR]%s %s\n"  "$RED" "$RESET" "$*"; }
info() { printf "%s[INFO]%s %s\n" "$BLUE" "$RESET" "$*"; }

# ------------- locate repo & dots -------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
REPO_ROOT="$SCRIPT_DIR"
DOTS_ROOT="$REPO_ROOT/hyprland-dots"
DOTS_CFG_ROOT="$DOTS_ROOT/config"

if [[ ! -d "$DOTS_CFG_ROOT" ]]; then
  err "Konnte KooL-Dots nicht finden unter: $DOTS_CFG_ROOT"
  err "Bitte stelle sicher, dass dieses Script im Repo-Root (dots-trippin) liegt und das Submodul vorhanden ist."
  exit 2
fi

# ------------- config -------------
# Pakete, die per stow in ~/.config/<name> verlinkt werden sollen (muss mit stow-hypr.sh konsistent sein)
STOW_PACKAGES=(
  Kvantum hypr waybar rofi wlogout swaync kitty wallust ags quickshell swappy
  btop cava fastfetch qt5ct qt6ct nvim dunst swww hyprlock hypridle hyprpaper
)

# Wichtige Laufzeit-Tools (binär) die von den Dots referenziert werden
RUNTIME_CMDS=(
  hyprctl hyprpaper hyprlock hypridle hyprpicker rofi waybar swaync wlogout kitty
  swww wallust jq brightnessctl playerctl grim slurp wl-copy swappy thunar
)

# ------------- counters -------------
FAILED=0
WARNED=0
PASSED=0

pass() { ok "$@"; PASSED=$((PASSED+1)); }
fail() { err "$@"; FAILED=$((FAILED+1)); }
softwarn() { warn "$@"; WARNED=$((WARNED+1)); }

# ------------- helpers -------------
have_cmd() { command -v "$1" >/dev/null 2>&1; }

# Prüft, ob im Zielverzeichnis mindestens ein Symlink auf das passende Dots-Verzeichnis zeigt
check_stow_pkg() {
  local name="$1"
  local src="$DOTS_CFG_ROOT/$name"
  local dst="$HOME/.config/$name"

  if [[ ! -d "$src" ]]; then
    softwarn "Quelle fehlt (übersprungen): $src"
    return 0
  fi
  if [[ ! -d "$dst" ]]; then
    softwarn "Zielverzeichnis fehlt: $dst (bitte ./stow-hypr.sh ausführen)"
    return 0
  fi

  local count=0
  # maxdepth 2 reicht für Top-Level Inhalte der Dots
  while IFS= read -r -d '' link; do
    local target
    # -f kann bei relativen Links wichtig sein
    target="$(readlink -f "$link" || true)"
    if [[ -n "${target:-}" && "$target" == "$src"* ]]; then
      count=$((count+1))
      break
    fi
  done < <(find "$dst" -maxdepth 2 -type l -print0 2>/dev/null || true)

  if (( count > 0 )); then
    pass "Stow-Links OK: $name → $dst (mind. 1 Link nach $src gefunden)"
  else
    softwarn "Keine symlinks von $dst nach $src gefunden. Bitte ./stow-hypr.sh ausführen"
  fi
}

grepf() { grep -E -- "$1" "$2" >/dev/null 2>&1; }

# ------------- checks -------------
echo
echo "${BOLD}==> 1) KooL-Dots Verlinkungen per stow${RESET}"
for p in "${STOW_PACKAGES[@]}"; do
  check_stow_pkg "$p"
done

echo
echo "${BOLD}==> 2) Wallust-Generierung / Farben${RESET}"
WAYBAR_WALLUST="$HOME/.config/waybar/wallust/colors-waybar.css"
HYPR_WALLUST="$HOME/.config/hypr/wallust/wallust-hyprland.conf"
WALLUST_TOML="$HOME/.config/wallust/wallust.toml"

if have_cmd wallust; then
  pass "wallust ist installiert"
else
  softwarn "wallust nicht gefunden. Farben werden ggf. nicht generiert"
fi

if [[ -f "$WAYBAR_WALLUST" ]]; then
  pass "Waybar Wallust-Farben vorhanden: $WAYBAR_WALLUST"
else
  softwarn "Waybar Wallust-Farben fehlen: $WAYBAR_WALLUST"
fi

if [[ -f "$HYPR_WALLUST" ]]; then
  pass "Hyprland Wallust-Farben vorhanden: $HYPR_WALLUST"
else
  softwarn "Hyprland Wallust-Farben fehlen: $HYPR_WALLUST"
fi

if [[ -f "$WALLUST_TOML" ]]; then
  pass "Wallust-Konfiguration vorhanden: $WALLUST_TOML"
else
  softwarn "Wallust-Konfiguration fehlt: $WALLUST_TOML (wird i. d. R. aus den Dots verlinkt)"
fi

if ! have_cmd swww; then
  softwarn "swww nicht gefunden. Wallpaper/Wallust-Pipeline per swww funktioniert dann nicht"
else
  pass "swww ist installiert"
fi

echo
echo "${BOLD}==> 3) Waybar-Integration${RESET}"
if have_cmd waybar; then
  pass "waybar ist installiert"
else
  softwarn "waybar nicht gefunden"
fi
WBCFG_DIR="$HOME/.config/waybar"
if [[ -d "$WBCFG_DIR" ]]; then
  pass "Waybar-Config-Verzeichnis vorhanden: $WBCFG_DIR"
else
  softwarn "Waybar-Config-Verzeichnis fehlt: $WBCFG_DIR"
fi
if [[ -f "$HOME/.config/waybar/style.css" ]]; then
  pass "Waybar Style vorhanden: ~/.config/waybar/style.css"
else
  # In manchen Dots landet CSS in ~/.config/waybar/style/*.css
  if compgen -G "$HOME/.config/waybar/style/*.css" >/dev/null; then
    pass "Waybar Styles vorhanden: ~/.config/waybar/style/*.css"
  else
    softwarn "Waybar Style fehlt (style.css oder style/*.css nicht gefunden)"
  fi
fi
if [[ -f "$WAYBAR_WALLUST" ]]; then
  pass "Waybar Wallust-Farben gefunden (siehe Abschnitt 2)"
else
  softwarn "Waybar Wallust-Farben (colors-waybar.css) fehlen (siehe Abschnitt 2)"
fi

echo
echo "${BOLD}==> 4) AGS-Integration${RESET}"
if have_cmd ags; then
  pass "ags ist installiert"
else
  softwarn "ags nicht gefunden"
fi
AGS_STYLE="$HOME/.config/ags/user/style.css"
if [[ -f "$AGS_STYLE" ]]; then
  pass "AGS Style vorhanden: $AGS_STYLE"
  if grepf 'waybar/wallust/colors-waybar.css' "$AGS_STYLE"; then
    pass "AGS Style importiert Wallust-Farben aus Waybar"
  else
    softwarn "AGS Style importiert keine Waybar/Wallust-Farben (optional, aber empfohlen)"
  fi
else
  softwarn "AGS Style fehlt: $AGS_STYLE (wird per stow aus den Dots verlinkt)"
fi

echo
echo "${BOLD}==> 5) Hyprland-Konfiguration${RESET}"
if have_cmd hyprctl; then
  pass "hyprctl gefunden"
else
  softwarn "hyprctl nicht gefunden (Hyprland evtl. nicht installiert)"
fi

HYPR_MAIN="$HOME/.config/hypr/hyprland.conf"
if [[ -f "$HYPR_MAIN" ]]; then
  pass "hyprland.conf vorhanden: $HYPR_MAIN"
  if grep -qF 'source = ~/.config/hypr/zz-local.conf' "$HYPR_MAIN"; then
    pass "zz-local.conf ist in hyprland.conf inkludiert (offnix-kool.nix Aktivierung)"
  else
    softwarn "zz-local.conf nicht in hyprland.conf inkludiert (Home-Manager Aktivierung evtl. nicht gelaufen)"
  fi
else
  softwarn "hyprland.conf fehlt: $HYPR_MAIN (Bitte stow-Hypr ausführen)"
fi

# Optional: prüfen ob UserDecorations die Wallust-Farben sourct
DECOR_CONF="$HOME/.config/hypr/UserConfigs/UserDecorations.conf"
if [[ -f "$DECOR_CONF" ]]; then
  if grep -qF 'wallust-hyprland.conf' "$DECOR_CONF"; then
    pass "UserDecorations.conf sourct Wallust-Farben"
  else
    softwarn "UserDecorations.conf sourct keine Wallust-Farben (optional)"
  fi
else
  softwarn "UserDecorations.conf nicht gefunden (ggf. andere Dots-Version)"
fi

echo
echo "${BOLD}==> 6) Laufzeit-Abhängigkeiten (Binaries)${RESET}"
MISSING_CMDS=()
for c in "${RUNTIME_CMDS[@]}"; do
  if have_cmd "$c"; then
    ok "cmd: $c"
  else
    warn "cmd fehlt: $c"
    MISSING_CMDS+=("$c")
  fi
done
if ((${#MISSING_CMDS[@]} == 0)); then
  pass "Alle Runtime-Tools gefunden"
else
  softwarn "Fehlende Tools: ${MISSING_CMDS[*]}"
fi

# ------------- Summary & Tipps -------------
echo
echo "${BOLD}==> Zusammenfassung${RESET}"
echo "  Passed: ${GREEN}${PASSED}${RESET}"
echo "  Warns : ${YELLOW}${WARNED}${RESET}"
echo "  Failed: ${RED}${FAILED}${RESET}"

echo
echo "${BOLD}==> Nächste Schritte (Tipps)${RESET}"
echo "- Falls Stow-Links fehlen: ${DIM}./stow-hypr.sh${RESET}"
echo "- Wallust-Farben generieren (eine Option):"
echo "    ${DIM}swww-daemon --format xrgb &${RESET}"
echo "    ${DIM}swww img ~/Pictures/wallpapers/IRGENDEINBILD.jpg${RESET}"
echo "  oder per Dots-Scripts:"
echo "    ${DIM}~/.config/hypr/UserScripts/WallpaperSelect.sh${RESET}  (SUPER+W)"
echo "    ${DIM}~/.config/hypr/UserScripts/WallpaperRandom.sh${RESET} (CTRL+ALT+W)"
echo "- Waybar neu starten: ${DIM}killall waybar; waybar & disown${RESET}"
echo "- Hyprland reload:    ${DIM}hyprctl reload${RESET}"

# Exit-Code: 0 wenn keine Fehler, 1 wenn Fehler
if (( FAILED > 0 )); then
  exit 1
fi
exit 0
