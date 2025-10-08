# README: Migrating Hyprland-Dots from stow to Nix/Home Manager

Goal
- Replace the GNU stow-based linking of JaKooLit Hyprland-Dots with a Nix/Home Manager driven setup.
- Make as much as possible reproducible and declarative via Nix, while retaining the Dots’ look-and-feel.

What changed
- A new Home Manager module exists at nix/home/hyprland-dots-xdg.nix.
- This module links the upstream Dots’ config/ subdirectories into ~/.config via xdg.configFile, without stow.
- It can also:
  - Ensure local overrides via ~/.config/hypr/zz-local.conf
  - Optionally install runtime tools used by the Dots
  - Optionally enable a user-level wayvnc service

Important: Two stable integration modes
- Mode A (recommended for “more via Nix”): Home Manager manages Hyprland settings. Use Dots only for apps (waybar, rofi, wallust, …). In this mode, exclude the upstream hypr config and keep your wayland.windowManager.hyprland Nix module.
- Mode B: Dots manage Hyprland config (hyprland.conf, UserConfigs, etc.). In this mode, disable HM’s Hyprland module to avoid conflicts.

Prerequisites (already present in this repo)
- Flake inputs:
  - hyprland (Hyprland)
  - hyprland-plugins (hyprexpo)
  - hyprland-dots (JaKooLit/Hyprland-Dots; flakes = false)
- specialArgs provide:
  - hyprlandDots (upstream repo)
  - hyprlandDotsLocal (optional local vendor override at nix/vendor/hyprland-dots if present)

How to enable (Mode A – HM controls Hyprland; Dots for everything else)
1) Import the module for your user
- In your HM user file (for example: nix/home/nixos.nix, nix/home/charly.nix, etc.), add:
  - ./hyprland-dots-xdg.nix to imports
2) Turn it on and exclude upstream hypr to keep HM as source of truth
- In the user config:
  programs.hyprlandDotsXdg = {
    enable = true;

    # install the tools Waybar/Rofi/etc used by the Dots
    installRuntimePackages = true;

    # Optional: enable a user-level WayVNC service
    enableWayvnc = true;

    # IMPORTANT for Mode A:
    # Keep HM-managed Hyprland config and do NOT link upstream “hypr/”
    excludeDirs = [ "hypr" ];

    # OPTIONAL: link more upstream dirs if you want them
    # linkDirs = [ "dunst" "swww" ];
    
    # OPTIONAL: if you later switch to Mode B and want local overrides in zz-local.conf
    # localIncludeContent = ''
    #   # example: per-machine overrides
    #   # monitor=eDP-1,2880x1800@60,auto,1.5
    # '';
  };
3) Rebuild
- User-only:
  home-manager switch
- Full NixOS:
  sudo nixos-rebuild switch

Result in Mode A
- Your Hyprland settings remain declarative in Nix (see nix/home/hyprland.nix).
- All surrounding app configs (waybar, rofi, swaync, hyprlock, hypridle, wallust, etc.) are linked from JaKooLit Dots into ~/.config via xdg.configFile, not stow.

How to enable (Mode B – Upstream Dots control Hyprland)
1) Import nix/home/hyprland-dots-xdg.nix for your user (like above).
2) Disable HM Hyprland module (to avoid config collisions), and do NOT exclude the upstream hypr dir:
- Example:
  wayland.windowManager.hyprland.enable = lib.mkForce false;
  programs.hyprlandDotsXdg = {
    enable = true;
    installRuntimePackages = true;
    enableWayvnc = true;

    # do NOT exclude “hypr” here
    # excludeDirs = [];
    
    ensureLocalInclude = true;
    localIncludeContent = ''
      # machine-specific Hypr overrides
      # monitor=eDP-1,2880x1800@60,auto,1.5
    '';
  };
3) Rebuild as usual.
4) Upstream hyprland.conf will be linked and your zz-local.conf will be included automatically (for your local overrides).

Runtime tools and services
- Set installRuntimePackages = true to add a sensible default set (rofi-wayland, waybar, wallust, swww, hyprpaper, grim, slurp, wl-clipboard, swappy, swaync, etc.).
- Set enableWayvnc = true to get a user-level wayvnc service. You can customize ~/.config/wayvnc/config content via programs.hyprlandDotsXdg.wayvncConfigText.

Migration tips from stow
- Stop running ./stow-hypr.sh.
- Existing symlinks in ~/.config can be left in place; xdg.configFile will lay down links as well. If you want a clean slate:
  - Move or remove ~/.config/* dirs that were stowed before, then rebuild via Nix.
- hypr-healthcheck.sh now suggests using home-manager switch or nixos-rebuild switch instead of stow.

Choosing between Mode A vs Mode B
- If your goal is “möglichst viel über Nix definiert,” Mode A is the natural fit:
  - wayland.windowManager.hyprland in Nix defines keybinds, plugins, exec-once, etc.
  - hyprland-dots-xdg provides all the surrounding themed configs (Waybar, Rofi, Wallust, …).
- If you want to stay very close to JaKooLit’s upstream experience, Mode B is fine:
  - Upstream hyprland.conf is linked; local tweaks go into zz-local.conf.

Troubleshooting checklist
- After enabling the module, rebuild:
  - home-manager switch (user scope)
  - sudo nixos-rebuild switch (system scope)
- Ensure the flake passes hyprlandDots and optionally hyprlandDotsLocal via specialArgs (flake.nix already does this in mkSpecialArgs).
- For plugin (hyprexpo), verify:
  - System sets HYPRLAND_PLUGINS or HM config includes plugins = [ hyprexpo ] (see nix/hosts/hyprland.nix and nix/home/hyprland.nix).
- Use hypr-healthcheck.sh to see if app configs and runtime tools are present.

FAQ
- Q: I get conflicts for hyprland.conf
  - A: You mixed Mode A and Mode B. Either:
    - Mode A: excludeDirs = [ "hypr" ] and keep HM Hyprland module enabled, or
    - Mode B: don’t exclude hypr, and disable HM Hyprland via mkForce false.
- Q: Can I override only some Dots subdirectories?
  - A: Yes. Use excludeDirs to skip, and linkDirs to add. Only existing directories will be linked.
- Q: How do I do host-specific Hypr tweaks when using Mode B?
  - A: Put them in programs.hyprlandDotsXdg.localIncludeContent. The module ensures hyprland.conf includes zz-local.conf.

Summary
- No more stow. The hyprland-dots-xdg module declaratively links JaKooLit’s Dots via Nix/Home Manager.
- Choose Mode A (more Nix/HM control) or Mode B (upstream hypr config), avoid mixing both.
- Rebuild with home-manager switch or sudo nixos-rebuild switch. Run hypr-healthcheck.sh for quick verification.