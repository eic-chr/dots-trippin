# Home-Manager Konfiguration für NixOS Systeme (Benutzer: ce)
{
  lib,
  pkgs,
  currentUser,
  userEmail,
  userFullName,
  hasPlasma,
  ...
}: {
  # Importiere deine bestehenden Module
  imports = [./core.nix ./git.nix ./shell.nix ./starship.nix ./kitty.nix];

  # Basis Home-Manager Einstellungen - angepasst für ca
  home = {
    username = currentUser;
    homeDirectory = "/home/${currentUser}";
    stateVersion = "25.11";

    # Zusätzliche NixOS-spezifische Pakete
    packages = with pkgs; [fzf git-crypt signal-desktop stow firefox];
  };

  # Git-Konfiguration für ca (überschreibt die aus git.nix)
  programs = {
    git = {
      userName = lib.mkForce userFullName; # Anpassen nach Bedarf
      userEmail = lib.mkForce userEmail; # Anpassen nach Bedarf
    };
    plasma = lib.mkIf hasPlasma {
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
  };

  services = {
    kdeconnect.enable = true;
    ssh-agent.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = false;
      pinentry.package = pkgs.pinentry-curses; # QT-Version für KDE
      defaultCacheTtl = 28800; # 8 Stunden
      maxCacheTtl = 86400; # 24 Stunden
    };
  };
}
