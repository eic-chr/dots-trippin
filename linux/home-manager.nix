{ config, lib, pkgs, ... }:
let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    ./zsh.nix
      (import "${home-manager}/nixos")
# ./plasma.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;


  home-manager.users.christian = {
    home.file = {
      "signature-ewolutions-ce.txt" = {
        text = ''
          __________________________________________________________

          EWolutions - Eickhoff & Wölfing IT Solutions GbR

          Einöd 395
          D-98663 Heldburg

          Telefon:   036 871 / 318 625
          E-Mail:  christian@ewolutions.de
          __________________________________________________________

          Bitte denken Sie an die Umwelt, bevor Sie diese Mail ausdrucken.
          '';
      };
    };
# /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.05";

    home.packages = [
      pkgs.oh-my-zsh
        pkgs.zsh
        pkgs.fzf
        pkgs.zsh-completions
        pkgs.zsh-powerlevel10k
        pkgs.zsh-syntax-highlighting
        pkgs.zsh-history-substring-search
        pkgs.thunderbird
        pkgs.signal-desktop
        pkgs.signal-cli
        pkgs.scli
        pkgs.ferdium
        pkgs.xorg.xset
        pkgs.python3
        pkgs.python311Packages.pip
        pkgs.libreoffice
        pkgs.keepassxc
        pkgs.nextcloud-client
        pkgs.cifs-utils
        pkgs.pgadmin4
        pkgs.kdePackages.kolourpaint
        ];


    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.home-manager.enable = true;
    programs.fzf.enable = true;
    programs.direnv.enable = true;

    programs.thunderbird = import ./thunderbird.nix; 
# programs.zoxide.enable = true;
# programs.atuin.enable = true;
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
    };
# programs.partition-manager.enable = true;
    programs.wezterm = {
      enable = true;
      extraConfig = lib.readFile ../wezterm.lua;
    };
# home.file.".p10k.zsh".source = ../p10k-config/.p10k.zsh;
  };

  fileSystems."/home/christian/nas_multimedia" = {
    device = "//nas1.eickhoff.lan/Multimedia";
    fsType = "cifs";
    options = [ 
      "credentials=/home/christian/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
  };
  fileSystems."/home/christian/nas_home" = {
    device = "//nas1.eickhoff.lan/home";
    fsType = "cifs";
    options = [ 
      "credentials=/home/christian/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
  };

  systemd.user.services.kbd-us-intl-service = {
    enable = true;
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    description = "Keyboard US International Airport Service";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''${pkgs.xorg.setxkbmap}/bin/setxkbmap us intl'';
      Environment = ''DISPLAY=:11.0'';
    };
  };

}
