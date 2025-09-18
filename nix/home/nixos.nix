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
  imports =
    [
      ./core.nix
      ./git.nix
      ./shell.nix
      ./starship.nix

      ./thunderbird.nix
      ./vscode.nix
      ./firefox.nix
    ]
    ++ lib.optionals (hostname != "offnix") [ ./kitty.nix ]
    ++ lib.optionals (hostname == "offnix") [ ./offnix-kool.nix ];

# Basis Home-Manager Einstellungen - angepasst für ca
  home.username = currentUser;
  home.homeDirectory = "/home/${currentUser}";
  home.stateVersion = "25.05";

# Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs.git = {
    userName = lib.mkForce userFullName; # Anpassen nach Bedarf
      userEmail = lib.mkForce userEmail; # Anpassen nach Bedarf
  };


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
        layouts = [
          {
            displayName = "US intl";
            layout = "us";
            variant = "intl";
          }
        ];
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
  home.packages = (with pkgs; [
# Browser (falls nicht system-weit installiert)
    ags
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
      waybar
      unstable.zed-editor
  ]) ++ lib.optionals (hostname == "offnix") [ pkgs.kitty ];
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
