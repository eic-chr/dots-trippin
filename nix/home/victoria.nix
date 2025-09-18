# Home-Manager Konfiguration für NixOS Systeme (Benutzer: ce)
{
  config,
  lib,
  pkgs,
  currentUser,
  userConfig,
  userEmail,
  userFullName,
  hasPlasma,
  hostname,
  ...
}: {
  # Importiere deine bestehenden Module
  imports = [./core.nix ./git.nix ./shell.nix ./starship.nix ./kitty.nix];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home.username = currentUser;
  home.homeDirectory = "/home/${currentUser}";
  home.stateVersion = "25.05";

  # Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs.git = {
    userName = lib.mkForce userFullName; # Anpassen nach Bedarf
    userEmail = lib.mkForce userEmail; # Anpassen nach Bedarf
  };

  programs.plasma = lib.mkIf hasPlasma {
    enable = true;
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
    };
  };

  # Zusätzliche NixOS-spezifische Pakete
  home.packages = with pkgs; [
    # Browser (falls nicht system-weit installiert)
    discord
    ferdium
    fzf
    git-crypt
    signal-desktop
    stow
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
