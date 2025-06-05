{ config, pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

  home.file = {
    ".p10k.zsh" = {
      text = ''
        # Minimal p10k configuration
        typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
        typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
          dir
          vcs
          prompt_char
        )
        typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
          status
          command_execution_time
          background_jobs
          time
        )
        typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
        typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
      '';
    };
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
    stow
    thunderbird
    xorg.xset
    zed-editor
    zsh
    zsh-completions
    zsh-history-substring-search
    zsh-powerlevel10k
    zsh-syntax-highlighting
    oh-my-zsh
    git
  ];
  systemd.user.services.dotfiles-setup = {
    Unit = {
      Description = "Setup dotfiles with stow";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${config.home.homeDirectory}/projects/ceickhoff/dots-trippin/setup.sh";
      RemainAfterExit = true;
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.stow pkgs.git pkgs.coreutils ]}"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
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
    # Git-Konfiguration
    git = {
      enable = true;
      userName = "Christian Eickhoff";
      userEmail = "christian@ewolutions.de";

      extraConfig = {
        init.defaultBranch = "main";
        push.default = "simple";
        pull.rebase = true;
        core.editor = "nvim";
        push.autoSetupRemote = true;
        branch.autosetupmerge = "always";
        branch.autosetuprebase = "always";
      };
    };
    gpg = {
      enable = true;
      settings = {
        # GPG-Agent als SSH-Agent verwenden
        use-agent = true;
      };
    };


    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
      extraConfig = ''
        Host *
            ServerAliveInterval 60
            ServerAliveCountMax 3
            IdentitiesOnly yes
            AddKeysToAgent yes
      '';
    };
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
      settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
    };


  };
  # SSH Public Key
  home.file.".ssh/id_ed25519.pub" = {
    text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9115pTLLpkhhZZh6qdlurEMHDZn7Gpv3yEfAxkNvhP christian@ewolutions.de
    '';
  };

  home.file.".ssh/config" = {
    text = ''
      Host *
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_ed25519
          ServerAliveInterval 60
          ServerAliveCountMax 3
    '';
  };
  # KDE Dark Mode Konfiguration
  home.file.".config/kdeglobals" = {
    text = ''
      [Colors:Button]
      BackgroundNormal=49,54,59

      [Colors:Selection]
      BackgroundNormal=61,174,233

      [Colors:Tooltip]
      BackgroundNormal=49,54,59

      [Colors:View]
      BackgroundNormal=35,38,41

      [Colors:Window]
      BackgroundNormal=49,54,59

      [General]
      ColorScheme=BreezeDark
      Name=Breeze Dark
      shadeSortColumn=true

      [KDE]
      LookAndFeelPackage=org.kde.breezedark.desktop
      widgetStyle=breeze

      [WM]
      activeBackground=49,54,59
      activeBlend=255,255,255
      activeForeground=252,252,252
    '';
  };

  # Plasma Theme
  home.file.".config/plasmarc" = {
    text = ''
      [Theme]
      name=breeze-dark
    '';
  };

  # Zed editor configuration
  home.file.".config/zed/settings.json" = {
    text = builtins.toJSON {
      theme = "One Dark";
      buffer_font_family = "FiraCode Nerd Font";
      buffer_font_size = 13;
      ui_font_family = "FiraCode Nerd Font";
      ui_font_size = 13;

      # Editor settings
      tab_size = 2;
      hard_tabs = false;
      soft_wrap = "editor_width";
      show_whitespace = "selection";
      remove_trailing_whitespace_on_save = true;
      ensure_final_newline_on_save = true;

      # Language settings
      languages = {
        "Nix" = {
          tab_size = 2;
          hard_tabs = false;
        };
        "Rust" = {
          tab_size = 4;
          hard_tabs = false;
        };
        "Go" = {
          tab_size = 4;
          hard_tabs = true;
        };
      };

      # AI assistant configuration for Claude
      assistant = {
        version = "2";
        default_model = {
          provider = "anthropic";
          model = "claude-sonnet-4-latest";
        };
        provider = {
          name = "anthropic";
        };
      };

      # Terminal settings
      terminal = {
        shell = {
          program = "zsh";
        };
        font_family = "FiraCode Nerd Font";
        font_size = 13;
      };

      # Git integration
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
        };
      };

      # Project panel
      project_panel = {
        button = true;
        default_width = 240;
        dock = "left";
        git_status = true;
      };

      # Telemetry
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-qt; # QT-Version für KDE
    defaultCacheTtl = 28800; # 8 Stunden
    maxCacheTtl = 86400; # 24 Stunden
  };
  services.ssh-agent.enable = true;
  # Host-specific configurations (handled in flake.nix for standalone mode)
}
