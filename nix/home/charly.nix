# Home-Manager Konfiguration für den zweiten Benutzer (ca) auf offnix
# Erweitere deine bestehende ca.nix mit diesen Parametern:
{ config, pkgs, lib, secondUsernix, hasPlasma ? false, ... }:

{
  # Importiere deine bestehenden Module (gleiche wie für ce)
  imports = [
    ./core.nix
    ./git.nix  
    ./shell.nix
    ./starship.nix
    ./kitty.nix
  ];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home.username = secondUsernix;  # "ca"
  home.homeDirectory = "/home/${secondUsernix}";
  home.stateVersion = "25.05";

  # Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs.git = {
    userName = lib.mkForce secondUsernix;  # Anpassen nach Bedarf
    userEmail = lib.mkForce "ca@example.com";  # Anpassen nach Bedarf
  };

  # Plasma-Konfiguration (möglicherweise andere Präferenzen als ce)
#  programs.plasma = lib.mkIf hasPlasma {
#    enable = true;
#    
#    # Eventuell andere Desktop-Einstellungen für den zweiten Benutzer
#    workspace = {
#      lookAndFeel = "org.kde.breeze.desktop";  # Heller Modus statt dunkel
#      colorScheme = "BreezeLight";
#      iconTheme = "breeze";
#      cursor.theme = "breeze_cursors";
#    };
#
#    # Gleiche Panel-Konfiguration wie der Hauptbenutzer
#    panels = [
#      {
#        location = "bottom";
#        widgets = [
#          "org.kde.plasma.kickoff"
#          "org.kde.plasma.pager"
#          "org.kde.plasma.icontasks"
#          "org.kde.plasma.marginsseparator"
#          "org.kde.plasma.systemtray"
#          "org.kde.plasma.digitalclock"
#        ];
#      }
#    ];
#
#    # Gleiche Shortcuts
#    shortcuts = {
#      ksmserver = {
#        "Lock Session" = [ "Screensaver" "Meta+L" ];
#      };
#      kwin = {
#        "Switch to Desktop 1" = "Meta+1";
#        "Switch to Desktop 2" = "Meta+2";
#        "Switch to Desktop 3" = "Meta+3";
#        "Switch to Desktop 4" = "Meta+4";
#      };
#    };
#  };

  # Zusätzliche Pakete für ca (eventuell andere Auswahl)
  home.packages = with pkgs; [
    # Browser
    firefox
    
    # Eventuell andere Tools für den zweiten Benutzer
    thunderbird  # Email-Client
    libreoffice  # Office-Suite
    
  ] ++ lib.optionals hasPlasma [
    # KDE-Pakete
    kdePackages.kate
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.okular
    kdePackages.spectacle
    kdePackages.gwenview
    kdePackages.kmail
  ];

}
