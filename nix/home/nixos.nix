# Home-Manager Konfiguration für NixOS Systeme (Benutzer: ce)
{
  config,
  lib,
  pkgs,
  unstable,
  currentUser,
  userConfig,
  userEmail,
  userFullName,
  hasPlasma,
  hostname,
  ...
}: {
  # Importiere deine bestehenden Module
  imports = [
    ./core.nix
    ./git.nix
    ./shell.nix
    ./starship.nix
    ./kitty.nix
    ./thunderbird.nix
    ./vscode.nix
    ./firefox.nix
  ];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home.username = currentUser;
  home.homeDirectory = "/home/${currentUser}";
  home.stateVersion = "25.05";

  # Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs.git = {
    userName = lib.mkForce userFullName; # Anpassen nach Bedarf
    userEmail = lib.mkForce userEmail; # Anpassen nach Bedarf
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi";
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Return, exec, kitty"
        "$mainMod, E, exec, dolphin"
        "$mainMod, Space, exec, rofi"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exit"
        "$mainMod, F, togglefloating,"
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      exec-once = [
        "waybar"
      ];
      decoration = {
        rounding = 5;

        active_opacity = 1.0;
        inactive_opacity = 0.99;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      input = {
        kb_layout = "us";
        kb_variant = "intl";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = false;
          };

        numlock_by_default = true;
      };

      gestures = {
        workspace_swipe = true;
      };

    };

  };
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
      ksmserver = {
        "Lock Session" = ["Screensaver" "Meta+L"];
      };
      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
      };
    };
  };

  # Zusätzliche NixOS-spezifische Pakete
  home.packages = with pkgs; [
    # Browser (falls nicht system-weit installiert)
    ansible
    ansible-lint
    discord
    ferdium
    fzf
    git-crypt
    glow
    pgadmin4
    texlive.combined.scheme-small
    md2pdf
    pandoc
    signal-desktop
    stow
    teamviewer
    wireshark
    unstable.zed-editor
  ];
  services.kdeconnect.enable = true;
  services.ssh-agent.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-curses; # QT-Version für KDE
    defaultCacheTtl = 28800; # 8 Stunden
    maxCacheTtl = 86400; # 24 Stunden
  };
}
