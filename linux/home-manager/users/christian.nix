{ config, pkgs, lib, ... }:

{
  home.file = {
    ".p10k.zsh".source = ../../p10k-config/.p10k.zsh;
    ".oh-my-zsh/custom/themes/powerlevel10k".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
    
    ".config/plasma-workspace/env/keyboard.sh" = {
      text = ''
        #!/bin/sh
        # Set keyboard layout
        setxkbmap us intl
        # Enable composition key (right alt)
        setxkbmap -option compose:ralt
        # Ensure changes persist
        xset r rate 200 30
      '';
      executable = true;
    };

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

  home.packages = with pkgs; [
    cifs-utils
    ferdium
    fzf
    xorg.setxkbmap
    kdePackages.merkuro
    kdePackages.kolourpaint
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-extras
    kdePackages.qtimageformats
    keepassxc
    libreoffice
    nextcloud-client
    pgadmin4
    python3
    python311Packages.pip
    scli
    signal-cli
    gpt4all
    signal-desktop
    thunderbird
    xorg.xset
    zsh
    zsh-completions
    zsh-history-substring-search
    zsh-powerlevel10k
    zsh-syntax-highlighting
    oh-my-zsh
    git
  ];

  # Systemd service for keyboard configuration
  systemd.user.services.keyboard-setup = {
    Unit = {
      Description = "Set keyboard layout to US International";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.xorg.setxkbmap}/bin/setxkbmap us intl && ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:ralt && ${pkgs.xorg.xset}/bin/xset r rate 200 30'";
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
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ZSH_THEME="powerlevel10k/powerlevel10k"
        eval "$(direnv hook zsh)"
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      '';
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "${pkgs.eza}/bin/exa";
        l = "${pkgs.eza}/bin/exa -la";
        tree = "${pkgs.eza}/bin/exa --tree";
        cat = "${pkgs.bat}/bin/bat";
        vi = "${pkgs.lunarvim}/bin/lvim";
        mmake = "${pkgs.gnumake}/bin/make -j$(${pkgs.coreutils}/bin/nproc)";
        garbage = "nix-collect-garbage -d && doas nix-collect-garbage -d";
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

    wezterm = {
      enable = true;
      extraConfig = lib.readFile ../../wezterm.lua;
    };
  };

  # Host-specific configurations
  home.packages = with pkgs;
    if config.networking.hostName == "devnix" then [
      docker
      vscode
      golangci-lint
      gopls
      gofumpt
      gotools
      gomodifytags
      impl
      iferr
      gotests
      delve
    ] else [];
}