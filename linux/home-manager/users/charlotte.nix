{ config, pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

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
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.kontact
    kdePackages.akonadi
    kdePackages.akonadi-mime
    kdePackages.akonadi-contacts
    kdePackages.akonadi-calendar
    kdePackages.kaddressbook
    kdePackages.korganizer
    keepassxc
    libreoffice
    nextcloud-client
    signal-desktop
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

  # Systemd service for KMail setup
  systemd.user.services.kmail-setup = {
    Unit = {
      Description = "Setup KMail with Charlotte's email account";
      After = [ "graphical-session.target" "akonadi.service" ];
      Wants = [ "akonadi.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/.local/bin/setup-kmail.sh";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs = {
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
      settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
    };
  };

  # Add KMail configuration with pre-configured account
  home.file = {
    ".config/kmailrc" = {
      text = ''
        [Composer]
        default-template=
        external-editor=false
        sticky-identity=true
        word-wrap=true

        [General]
        first-start=false
        previous-version=5.21.0
        startup-folder=inbox

        [Reader]
        close-after-reply-or-forward=false
        html-mail=true
        mdn-default-policy=ask
        show-colorbar=true
        show-spam-status=true
      '';
    };

    ".config/emailidentities" = {
      text = ''
        [Identity #0]
        Email Address=charlotte@ewolutions.de
        Identity Name=Charlotte Amend
        Name=Charlotte Amend
        Organization=EWolutions - Eickhoff & Wölfing IT Solutions GbR
        Reply-To Address=
        Signature Type=0
        uoid=1
      '';
    };

    ".config/mailtransports" = {
      text = ''
        [Transport 1]
        host=mail.ewolutions.de
        id=1
        name=EWolutions SMTP
        port=587
        type=smtp
        encryption=TLS
        requiresAuthentication=true
        userName=charlotte@ewolutions.de
        storePassword=false
      '';
    };

    ".config/emaildefaults" = {
      text = ''
        [Defaults]
        defaultIdentityId=1
        defaultTransportId=1
      '';
    };

    ".config/kmail2rc" = {
      text = ''
        [Composer]
        default-identity=1
        previous-identity=1

        [General]
        SystemTrayEnabled=true
        first-start=false

        [Network]
        ImapConnectionPooling=true
      '';
    };

    ".config/akonadi/agentsrc" = {
      text = ''
        [Instances]
        akonadi_imap_resource_0=akonadi_imap_resource

        [Resource akonadi_imap_resource_0]
        Name=EWolutions IMAP
        Identifier=akonadi_imap_resource_0
      '';
    };

    ".local/share/akonadi/agents/akonadi_imap_resource/akonadi_imap_resource_0rc" = {
      text = ''
        [network]
        ImapServer=mail.ewolutions.de
        ImapPort=993
        Safety=SSL
        UserName=charlotte@ewolutions.de
        Password=
        SubscriptionEnabled=true
        DisconnectedModeEnabled=true
        IntervalCheckEnabled=true
        IntervalCheckTime=5

        [cache]
        DisconnectedModeEnabled=true
        
        [siever]
        SieveSupport=false
        SievePort=4190
        SieveAlternateURL=
        SieveCustomUsername=
        
        [General]
        TrashCollection=0
      '';
    };

    ".config/autostart/akonadi-setup.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Akonadi Email Setup
        Exec=${pkgs.bash}/bin/bash -c 'sleep 10 && akonadictl start && sleep 5 && akonadictl restart'
        Hidden=false
        NoDisplay=false
        X-GNOME-Autostart-enabled=true
        StartupNotify=false
      '';
    };

    ".local/bin/setup-kmail.sh" = {
      text = ''
        #!/bin/bash
        # Setup script for KMail with Charlotte's account
        
        # Wait for desktop session to be ready
        sleep 15
        
        # Start Akonadi if not running
        if ! pgrep -x "akonadi" > /dev/null; then
            akonadictl start
            sleep 10
        fi
        
        # Configure Akonadi agents
        akonadictl restart
        sleep 5
        
        # Add IMAP resource if not exists
        if ! akonadictl list | grep -q "akonadi_imap_resource_0"; then
            akonadictl add akonadi_imap_resource akonadi_imap_resource_0
            sleep 3
        fi
        
        # Synchronize collections
        akonadictl restart
        
        echo "KMail setup completed for Charlotte"
      '';
      executable = true;
    };
  };
}