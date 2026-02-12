{pkgs, ...}: {
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

  imports = [./services/aerospace.nix];
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
      "cryptomator"
      "chromium"
      "keepassxc"
      "nextcloud"
      # "raycast"
      "shottr"
      "stats"
      # "wireshark-app"
      # "google-chrome"
    ];
  };
}
