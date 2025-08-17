# Home-Manager Konfiguration für NixOS Systeme (Benutzer: ce)
{ config, pkgs, lib, usernix, useremail, hasPlasma ? false, ... }:

{
  # Importiere deine bestehenden Module
  imports = [
    ./core.nix
    ./git.nix
    ./shell.nix
    ./starship.nix
    ./kitty.nix
    ./thunderbird.nix
    ./vscode.nix
  ];

  # Basis Home-Manager Einstellungen
  home.username = usernix;
  home.homeDirectory = "/home/${usernix}";
  home.stateVersion = "25.05";

  # Überschreibe Git-Einstellungen für den usernix Benutzer
  programs.git = {
    userName = lib.mkForce "Christian Eickhoff";
    userEmail = lib.mkForce useremail;
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
    input = {
      touchpads = [
        {
          enable = true;
          name = "Apple Inc. Apple Internal Keyboard / Trackpad";
          vendorId = "05ac";     # Apple Vendor ID
          productId = "0263";    # Dein MacBook Trackpad
          naturalScroll = true;  # Traditionelles Scrolling!
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
        "Lock Session" = [ "Screensaver" "Meta+L" ];
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
    ferdium
    fzf
    git-crypt
    pgadmin4
    signal-desktop
    stow
    zed-editor
    
  ];

  services.ssh-agent.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-curses; # QT-Version für KDE
    defaultCacheTtl = 28800; # 8 Stunden
    maxCacheTtl = 86400; # 24 Stunden
  };
}
