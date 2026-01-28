{pkgs, ...}: let
  modKey = "cmd";
in {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    # Core system tools (alle Benutzer brauchen sie)
    git # Version control - systemweit nötig
    direnv # Environment management - systemweit besser
    just

    # System administration
    sshpass # SSH-Tool für Automatisierung

    # Spell checking (systemweit verfügbar)
    (aspellWithDicts (dicts: with dicts; [de en en-computers]))
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  services.aerospace = {
    enable = true;
    settings = {
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      on-window-detected = [
        {
          "if".app-name-regex-substring = "citrix";
          run = "layout floating";
        }
      ];
      accordion-padding = 30;

      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer = {
          left = 8;
          bottom = 8;
          top = 8;
          right = 8;
        };
      };
      mode.main.binding = {
        "${modKey}-enter" = "exec-and-forget ${pkgs.kitty}/bin/kitty --single-instance";
        # Layout commands
        "${modKey}-slash" = "layout tiles horizontal vertical";
        "${modKey}-comma" = "layout accordion horizontal vertical";
        "${modKey}-shift-space" = "layout floating tiling";
        "${modKey}-shift-f" = "fullscreen";

        # Focus commands
        "${modKey}-h" = "focus left";
        "${modKey}-j" = "focus down";
        "${modKey}-k" = "focus up";
        "${modKey}-l" = "focus right";

        # Move commands
        "${modKey}-shift-h" = "move left";
        "${modKey}-shift-j" = "move down";
        "${modKey}-shift-k" = "move up";
        "${modKey}-shift-l" = "move right";

        # Resize commands
        "${modKey}-minus" = "resize smart -50";
        "${modKey}-equal" = "resize smart +50";

        # Workspace commands (numbers)
        "${modKey}-1" = "workspace 1";
        "${modKey}-2" = "workspace 2";
        "${modKey}-3" = "workspace 3";
        "${modKey}-4" = "workspace 4";
        "${modKey}-5" = "workspace 5";
        "${modKey}-6" = "workspace 6";
        "${modKey}-7" = "workspace 7";
        "${modKey}-8" = "workspace 8";
        "${modKey}-9" = "workspace 9";

        # Move to workspace (numbers)
        "${modKey}-shift-1" = "move-node-to-workspace 1";
        "${modKey}-shift-2" = "move-node-to-workspace 2";
        "${modKey}-shift-3" = "move-node-to-workspace 3";
        "${modKey}-shift-4" = "move-node-to-workspace 4";
        "${modKey}-shift-5" = "move-node-to-workspace 5";
        "${modKey}-shift-6" = "move-node-to-workspace 6";
        "${modKey}-shift-7" = "move-node-to-workspace 7";
        "${modKey}-shift-8" = "move-node-to-workspace 8";
        "${modKey}-shift-9" = "move-node-to-workspace 9";

        # Workspace navigation
        "${modKey}-tab" = "workspace-back-and-forth";
        "${modKey}-shift-tab" = "move-workspace-to-monitor --wrap-around next";

        # Enter service mode
        "${modKey}-shift-semicolon" = "mode service";
      };
      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];

        "${modKey}-shift-h" = ["join-with left" "mode main"];
        "${modKey}-shift-j" = ["join-with down" "mode main"];
        "${modKey}-shift-k" = ["join-with up" "mode main"];
        "${modKey}-shift-l" = ["join-with right" "mode main"];
      };
    };
  };
  homebrew = {
    enable = true;

    # Apple Silicon
    brewPrefix = "/opt/homebrew/bin";

    # Was darf nix-darwin steuern?
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [];

    brews = [
      #"mas" "watch" "httpie"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "caffeine"
      # "raycast"
      "shottr"
      "stats"
      # "wireshark-app"
      # "google-chrome"
    ];
  };
}
