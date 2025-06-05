{ config, pkgs, lib, ... }:

{
  home.file = {
    "signature-ewolutions-ca.txt" = {
      text = ''
        __________________________________________________________

        EWolutions - Eickhoff & Wölfing IT Solutions GbR

        Einöd 395
        D-98663 Heldburg

        Telefon:   036 871 / 318 625
        E-Mail:  charlotte@ewolutions.de
        __________________________________________________________

        Bitte denken Sie an die Umwelt, bevor Sie diese Mail ausdrucken.
      '';
    };

    ".config/plasma-workspace/env/keyboard.sh" = {
      text = ''
        #!/bin/sh
        # Set German MacBook keyboard layout
        setxkbmap de mac
        # Enable composition key (right alt)
        setxkbmap -option compose:ralt
        # Ensure changes persist
        xset r rate 200 30
      '';
      executable = true;
    };
  };

  home.packages = with pkgs; [
    cifs-utils
    ferdium
    xorg.setxkbmap
    kdePackages.merkuro
    kdePackages.kolourpaint
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-extras
    kdePackages.qtimageformats
    keepassxc
    libreoffice
    nextcloud-client
    signal-desktop
    thunderbird
    xorg.xset
  ];

  # Systemd service for keyboard configuration
  systemd.user.services.keyboard-setup = {
    Unit = {
      Description = "Set keyboard layout to German MacBook";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.xorg.setxkbmap}/bin/setxkbmap de mac && ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt && ${pkgs.xorg.xset}/bin/xset r rate 200 30'";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs = {
    thunderbird = import ../../thunderbird.nix;
    
    zsh = {
      enable = true;
      initExtra = ''
        bindkey -v
        eval "$(direnv hook zsh)"
      '';
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "${pkgs.eza}/bin/exa";
        l = "${pkgs.eza}/bin/exa -la";
        tree = "${pkgs.eza}/bin/exa --tree";
        cat = "${pkgs.bat}/bin/bat";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };

    starship = {
      enable = true;
      settings = builtins.fromTOML (lib.readFile ../../starship/starship.toml);
    };
  };
}