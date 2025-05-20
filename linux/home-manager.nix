{ lib, pkgs, ... }:
let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{


  imports = [
    (import "${home-manager}/nixos")
# ./git.nix
# ./plasma.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;


  home-manager.users.christian = {
    home.file.".p10k.zsh".source = ../p10k-config/.p10k.zsh;
    home.file.".oh-my-zsh/custom/themes/powerlevel10k".source =
      "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
    home.file.".config/autostart-scripts/setxkbmap.sh" = {
      text = ''
#!/bin/bash
        setxkbmap us intl
        '';
      executable = true;
    };

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
    home.stateVersion = "24.11";

    home.packages = [
      pkgs.cifs-utils
        pkgs.ferdium
        pkgs.fzf
        pkgs.kdePackages.kolourpaint
        pkgs.kdePackages.kdegraphics-thumbnailers
        pkgs.kdePackages.kio-extras
        pkgs.kdePackages.qtimageformats
        pkgs.keepassxc
        pkgs.libreoffice
        pkgs.nextcloud-client
        pkgs.pgadmin4
        pkgs.python3
        pkgs.python311Packages.pip
        pkgs.scli
        pkgs.signal-cli
        pkgs.gpt4all
        pkgs.signal-desktop
        pkgs.thunderbird
        pkgs.xorg.xset
        pkgs.zsh
        pkgs.zsh-completions
        pkgs.zsh-history-substring-search
        pkgs.zsh-powerlevel10k
        pkgs.zsh-syntax-highlighting
        pkgs.oh-my-zsh
        pkgs.git
        ];


    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.home-manager.enable = true;
    programs.fzf.enable = true;
    programs.direnv.enable = true;

    programs.thunderbird = import ./thunderbird.nix; 
    programs.zsh = {
      enable = true;
      initExtra = ''
        bindkey -v
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme;
        ZSH_THEME="powerlevel10k/powerlevel10k"
        eval "$(direnv hook zsh)"
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      '';
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      # plugins = [
      #   {
      #     name = "powerlevel10k";
      #     src = pkgs.zsh-powerlevel10k;
      #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      #   }
      # ];
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
        # theme = "powerlevel10k/powerlevel10k";
      };
    };

# programs.zoxide.enable = true;
# programs.atuin.enable = true;
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
    };
# programs.zsh = {
#   enable = true;
#   initExtra = ''
#     eval "$(direnv hook zsh)"
#   '';
#   };
# programs.partition-manager.enable = true;
    programs.wezterm = {
      enable = true;
      extraConfig = lib.readFile ../wezterm.lua;
    };
# home.file.".p10k.zsh".source = ../p10k-config/.p10k.zsh;
  };

  fileSystems."/home/christian/Scans" = {
    device = "//nas1.eickhoff.lan/Scans";
    fsType = "cifs";
    options = [ 
      "credentials=/home/christian/.smb_crd"
      "uid=1000" # Your user ID
      "gid=1000" # Your group ID
    ]; # Path to the credentials file
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
