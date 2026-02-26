# How to theme or add Waybars in ZaneyOS

This guide shows how ZaneyOS selects and configures Waybar, how to add your own Waybar module, and how to customize fonts, sizes, colors, icons, widgets, and layout. It also calls out where to put scripts and a critical note about git add to avoid rebuild failures.


## Current Waybar modules available
Saved in modules/home/waybar/:
- waybar-tony.nix
- waybar-ddubs.nix
- waybar-ddubsos-v1.nix
- waybar-dwm.nix
- waybar-curved.nix
- waybar-simple.nix
- waybar-ddubs-2.nix
- waybar-mecha.nix
- waybar-dwm2.nix
- waybar-nekodyke.nix
- Jerry-waybar.nix
- waybar-TheBlackDon.nix


## Where you select your Waybar
Select the Waybar module in hosts/default/variables.nix via waybarChoice. Example (actual excerpt):
```nix path=/home/dwilliams/ZaneyOS/hosts/default/variables.nix start=73
  # Set Waybar
  # Includes alternates such as:
  # Comment out the current choice and uncomment the one you want
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/Jerry-waybars.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-mecha.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
```
Notes:
- Ensure the file path matches an actual file name under modules/home/waybar/. For example, the list includes Jerry-waybar.nix (singular), but the commented example shows Jerry-waybars.nix (plural). Use the actual filename to avoid build errors.


## CRITICAL: git add or rebuild will fail
When you add a new Waybar file or any scripts it uses, you must stage them in git before rebuilding, or Nix will not see those paths and the build will fail.
- Example:
```bash path=null start=null
# Add your new module and scripts
git add modules/home/waybar/my-waybar.nix modules/home/waybar/scripts/my-widget.sh
# Commit (optional but recommended)
git commit -m "Add my Waybar module and widget script"
```


## How Waybar modules are structured here
Most Waybar modules follow this pattern:
- They expose a Home Manager module that sets programs.waybar.settings (JSON-like config) and programs.waybar.style (CSS).
- They also copy any helper scripts to ~/.config/waybar/scripts via a shared scripts directory.

Example: waybar-tony.nix copies scripts and sets Waybar config and CSS:
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=15
  # Configure & Theme Waybar (Tony)
  home.file = builtins.listToAttrs (map
    (name: {
      name = ".config/waybar/scripts/" + name;
      value = {
        source = "${scriptsDir}/${name}";
        executable = true;
      };
    })
    scripts);

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "custom/startmenu" "hyprland/workspaces" "custom/sep" "tray" "custom/sep" "hyprland/window" "custom/sep"
        ];
        modules-center = [ "custom/sep" "idle_inhibitor" "custom/notification" "custom/sep" ];
        modules-right = [ "custom/sep" "pulseaudio" "network" "cpu" "memory" "clock" "custom/sep" "custom/power" ];
        # ... component configs ...
      }
    ];
    style = concatStrings [
      ''
        @define-color bg    #1a1b26;
        @define-color fg    #a9b1d6;
        * { font-family: "JetBrainsMono Nerd Font", monospace; font-size: 16px; font-weight: bold; }
        window#waybar { background-color: @bg; color: @fg; }
        #workspaces button { padding: 0 6px; color: @cyn; }
        #clock { color: @cyn; border-bottom: 4px solid @cyn; }
        #pulseaudio { color: @blu; border-bottom: 4px solid @blu; }
        #idle_inhibitor.activated { color: @grn; border-bottom: 4px solid @grn; }
      ''
    ];
  };
```

Key takeaways:
- Layout is controlled by modules-left, modules-center, and modules-right arrays.
- Individual module settings (e.g., hyprland/workspaces, pulseaudio) are configured under the same top-level object.
- CSS controls fonts, sizes, colors, borders, and spacing.
- scriptsDir = ./scripts relative to the module file; any files inside that directory are installed into ~/.config/waybar/scripts and made executable.


## Add your own Waybar module (step-by-step)
1) Copy an existing module as a starting point, e.g.:
```bash path=null start=null
cp modules/home/waybar/waybar-simple.nix modules/home/waybar/my-waybar.nix
```
2) (Optional) Add any helper scripts your widgets will use into modules/home/waybar/scripts/ (they will be installed to ~/.config/waybar/scripts automatically by modules using scriptsDir = ./scripts).
3) Point variables.nix to your new module:
```nix path=/home/dwilliams/ZaneyOS/hosts/default/variables.nix start=81
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
```
Change the active line to:
```nix path=null start=null
waybarChoice = ../../modules/home/waybar/my-waybar.nix;
```
4) Stage your files before rebuilding (critical):
```bash path=null start=null
git add modules/home/waybar/my-waybar.nix modules/home/waybar/scripts/*
```
5) Rebuild as you normally do for ZaneyOS.


## Customization examples
Below are quick edits you can make, demonstrated using existing modules.

1) Change font family and size (CSS)
- In waybar-tony.nix:
```css path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=207
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 16px;
    font-weight: bold;
}
```
Change font-family and font-size to your preference.

2) Move widgets left/center/right
- In any module, edit modules-left, modules-center, modules-right arrays. For example in waybar-simple.nix:
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-simple.nix start=28
modules-center = [ "hyprland/workspaces" ];
modules-left = [ "custom/startmenu" "custom/arrow6" "pulseaudio" "cpu" "memory" "idle_inhibitor" "custom/arrow7" "hyprland/window" ];
modules-right = [ "custom/arrow4" "custom/hyprbindings" "custom/arrow3" "custom/notification" "custom/arrow3" "custom/power" "battery" "custom/arrow2" "tray" "custom/arrow1" "clock" ];
```
Just reorder or move entries between arrays to place widgets where you want.

3) Change colors and button styles
- In waybar-tony.nix, CSS color variables and workspace button styling:
```css path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=218
#workspaces button {
    padding: 0 6px;
    color: @cyn;
    background: transparent;
    border-bottom: 3px solid @bg;
}
#workspaces button.active {
    color: @cyn;
    border-bottom: 3px solid @mag;
}
```
Adjust colors (e.g., @cyn, @mag) or borders as desired. You can also define your own @define-color variables at the top of the CSS block.

4) Add icons or change labels
- Many modules set format and format-icons. Example (pulseaudio) in waybar-ddubs.nix:
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-ddubs.nix start=104
"pulseaudio" = {
  format = "{icon} {volume}% {format_source}";
  format-icons = {
    headphone = "";
    default = [ "" "" "" ];
  };
};
```
Replace icons with Nerd Font glyphs you prefer.

5) Add a new widget that runs a script
- Waybar custom modules can execute scripts and display the output. Put your script in modules/home/waybar/scripts/ and configure a custom module:
```nix path=null start=null
"custom/mywidget" = {
  exec = "~/.config/waybar/scripts/my-widget.sh";
  return-type = "json";   # or "text" depending on your script
  interval = 5;            # seconds
  format = "{}";          # how to render the output
  on-click = "kitty -e my-tool";
};
```
- Scripts placed in modules/home/waybar/scripts/ are installed to ~/.config/waybar/scripts and marked executable by modules that include the home.file mapping.

6) Make the bar floating or docked
- Waybar supports a mode field; CSS margins/transparency give a floating look:
```nix path=null start=null
settings = [
  {
    layer = "top";
    position = "top";
    mode = "overlay";   # overlay (floats), or "dock" (reserves space), or "invisible"
    # ...
  }
];
```
- CSS for floating effect:
```css path=null start=null
window#waybar {
  background: rgba(0, 0, 0, 0.6);
  margin: 6px 10px;       /* space from screen edges */
  border-radius: 12px;
}
```

7) Known Waybar modules you’ll see in ZaneyOS configs
- Hyprland modules: hyprland/workspaces, hyprland/window, wlr/taskbar (wlroots taskbar)
- System modules: clock, tray, cpu, memory, network, disk, battery, bluetooth, backlight, idle_inhibitor, mpris, temperature, pulseaudio
- Custom modules: custom/* (e.g., custom/power, custom/notification, custom/startmenu, etc.)


## Where to store scripts that widgets call
- Place scripts under modules/home/waybar/scripts/.
- Many Waybar modules here include:
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-ddubs.nix start=14
home.file = builtins.listToAttrs (map (name: {
  name = ".config/waybar/scripts/" + name;
  value = { source = "${scriptsDir}/${name}"; executable = true; };
}) scripts);
```
This copies all files from ./scripts (next to the module file) to ~/.config/waybar/scripts and makes them executable, so your Waybar configuration can reference them as ~/.config/waybar/scripts/<script>.


## Troubleshooting
- Build fails with a path error: make sure any new .nix files and scripts are tracked in git (git add). Nix requires the files to be present in the store; untracked files referenced in the config will cause errors.
- Wrong filename in variables.nix: ensure the chosen waybarChoice path exactly matches an existing file.
- Icons not showing: verify you have a Nerd Font installed (e.g., JetBrainsMono Nerd Font) and selected in CSS.
- Widgets missing: confirm the widget is listed in modules-left/center/right arrays and that its settings block exists.


## Quick recipe: add and use a new Waybar
1) Create modules/home/waybar/my-waybar.nix (copy an existing one and edit).
2) If needed, drop helper scripts into modules/home/waybar/scripts/.
3) Update hosts/default/variables.nix:
```nix path=null start=null
waybarChoice = ../../modules/home/waybar/my-waybar.nix;
```
4) Stage files before rebuilding:
```bash path=null start=null
git add modules/home/waybar/my-waybar.nix modules/home/waybar/scripts/*
```
5) Rebuild.
