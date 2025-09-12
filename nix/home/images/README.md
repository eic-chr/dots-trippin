# Wallpapers (Hyprpaper)

This directory is a placeholder for your wallpaper images, kept under version control.

How this integrates with your setup
- Hyprpaper is configured in `~/.config/hypr/hyprpaper.conf` to use: `~/.config/hypr/wallpapers/default.jpg`.
- On Hyprland startup, hyprpaper is launched automatically (see exec-once in your Hyprland module).
- You need to ensure that `~/.config/hypr/wallpapers/default.jpg` exists.

Recommended workflow
1) Put one or more images into this folder (e.g. `nix/home/images/mywall.jpg`).
2) Choose your default wallpaper and make it available at `~/.config/hypr/wallpapers/default.jpg` by either:
   - Quick and manual:
     - Copy or symlink your chosen image to `~/.config/hypr/wallpapers/default.jpg`.
   - Managed via Home Manager (preferred):
     - Add a file mapping so Home Manager installs the image to the expected path.
     - Example (to place a single file):
       - `home.file.".config/hypr/wallpapers/default.jpg".source = ./images/mywall.jpg;`
     - Example (to install the entire images directory as your wallpapers directory):
       - `home.file.".config/hypr/wallpapers" = { source = ./images; recursive = true; };`

Per-monitor wallpapers (optional)
- You can pin wallpapers to specific outputs in `~/.config/hypr/hyprpaper.conf`:
  - `wallpaper = eDP-1,~/.config/hypr/wallpapers/laptop.jpg`
  - `wallpaper = HDMI-A-1,~/.config/hypr/wallpapers/desk.jpg`
- Make sure those files exist at the specified paths (use the mappings above).

Applying changes
- If hyprpaper is already running, restart it from a terminal:
  - `pkill hyprpaper && hyprpaper &`
- Or log out and back in to let Hyprland start it fresh.

Tip
- Name your primary wallpaper `default.jpg` and keep additional wallpapers here as well. This keeps your configuration simple and reproducible.

Why this folder must be tracked (flakes)
- When using flakes, sources referenced in Home Manager must exist in the flake store.
- If nix/home/images is empty or not committed to git, building the flake may fail with:
  - error: path '.../nix/home/images' does not exist
- Keep at least one tracked file here (e.g. default.jpg or a .keep file) to ensure the path exists.

Enable/disable wallpapers deployment
- Enabled (default in this repo):
  - The wallpapers folder is deployed to ~/.config/hypr/wallpapers.
- Disable deployment:
  - Remove the folder or leave it untracked/empty so it’s not included in the flake store (the configuration guards against missing paths).
  - Alternatively, comment out the Home Manager mapping:
    - home.file.".config/hypr/wallpapers" = { source = ./images; recursive = true; };
- Re-enable:
  - Add images (at least default.jpg) and commit them to git, or add an empty placeholder like nix/home/images/.keep.
  - Rebuild; hyprpaper will pick up ~/.config/hypr/wallpapers/default.jpg at next login or after restarting hyprpaper.