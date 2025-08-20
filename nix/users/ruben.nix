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
  imports = [
    ./core.nix
    ./git.nix
    ./shell.nix
    ./starship.nix
    ./kitty.nix
    ./thunderbird.nix
    ./vscode.nix
  ];


  # Zusätzliche NixOS-spezifische Pakete
  home.packages = with pkgs; [
    # Browser (falls nicht system-weit installiert)
    ansible
    ansible-lint
    discord
    ferdium
    fzf
    git-crypt
    teamviewer
    wireshark
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
