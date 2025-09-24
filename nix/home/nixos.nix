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
    source = ../scripts/sidepad/sidepad-dispatcher.sh;
    executable = true;
  };

  home.file.".config/sidepad/sidepad" = {
    source = ../scripts/sidepad/sidepad.sh;
    executable = true;
  };

  home.file.".config/sidepad/pads" = {
    source = ../scripts/sidepad/pads;
    recursive = true;
  };

  home.file.".config/ml4w/settings/sidepad-active".text = ''
    signal
  '';

  home.file.".config/hypr/UserConfigs/Keybinds.local.conf".text = ''
    # Toggle sidebar
    unbind = $mainMod, S
    bind = $mainMod, S, exec, ~/.config/ml4w/scripts/sidepad.sh
    # Expand/shrink handled by toggle when visible (upstream behavior)
    # Select pad (rofi)
    bind = $mainMod, Shift+B, exec, ~/.config/ml4w/scripts/sidepad.sh --select
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
