
{ config, pkgs, ... }:
{
  programs.plasma = {
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
}
