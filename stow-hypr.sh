
#!/usr/bin/env bash
set -euo pipefail

# Vom Repo-Root aus ausführen
# Passe die Liste nach Bedarf an (weitere Kandidaten: ags quickshell wallust swappy btop cava fastfetch qt5ct qt6ct Kvantum nvim dunst swww hyprlock hypridle hyprpaper)
packages=(waybar Kvantum hypr rofi wlogout swaync kitty wallust ags quickshell swappy btop cava fastfetch qt5ct qt6ct dunst swww hyprlock hypridle hyprpaper)

for pkg in "${packages[@]}"; do
  src="./hyprland-dots/config/$pkg"
  dst="$HOME/.config/$pkg"

  if [[ -d "$src" ]]; then
    echo "==> Stowing $pkg -> $dst"
    mkdir -p "$dst"
    # Handle existing non-stow wallust.toml by backing it up
    if [[ "$pkg" == "wallust" ]]; then
      if [[ -e "$dst/wallust.toml" && ! -L "$dst/wallust.toml" ]]; then
        ts=$(date +%Y%m%d-%H%M%S)
        echo "    Found existing $dst/wallust.toml (not a symlink). Backing up to wallust.toml.bak.$ts"
        mv "$dst/wallust.toml" "$dst/wallust.toml.bak.$ts"
      fi
    fi
    # zuerst evtl. vorhandene Stows für dieses Ziel lösen (falls du umstellst)
    stow -v -D -d ./hyprland-dots/config -t "$dst" "$pkg" 2>/dev/null || true
    # dann korrekt stowen
    stow -v -R -d ./hyprland-dots/config -t "$dst" "$pkg"
  else
    echo "==> Skip $pkg (Quelle nicht vorhanden: $src)"
  fi
done
