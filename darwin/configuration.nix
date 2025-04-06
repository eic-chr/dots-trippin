{ config, lib, pkgs, ... }:
{
  users.users.christianeickhoff = {
    name = "christianeickhoff";
    home = "/Users/christianeickhoff";
  };
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@admin" "christianeickhoff" ];
      substituters = [ "https://cache.nixos.org/" ];
      trusted-substituters = [ "https://cache.nixos.org/" ];
      auto-optimise-store = true;
    };
    gc.automatic = true;
  };
system.stateVersion = 5;
ids.gids.nixbld = 30000;
  nix.configureBuildUsers = true;
  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Not sure if this only applies to the internal keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  homebrew.enable = false;
  # clean up no longer used homebrew stuff
  homebrew.onActivation.cleanup = "zap";
  homebrew.taps = [
    #"railwaycat/emacsmacport"
    "homebrew/cask"
    # kafkactl
    "deviceinsight/packages"
    "quarkusio/tap/quarkus"
    # tfswitch
    "warrensbox/tap"
    "brew/overrides"
    "zix99/rare"
  ];
  homebrew.brews = [
    # yubikey
    "bash-language-server"
    "quarkus"
    #"colima"
    # "docker"
    # "docker-compose"
    "gnupg"
    "graphviz"
    "hopenpgp-tools"
    "jdtls"
    "make"
    "pinentry-mac"
    "python-lsp-server"
    "terraform"
    "terraform-docs"
    "terraform-ls"
    "typescript-language-server"
    "yaml-language-server"
    # dep for ykman
#    "cryptography"
    "ykman"
    "yubikey-personalization"
    "zellij"
    "rare"
    #"docker-buildx"
    "vscode-langservers-extracted"
    "brew/overrides/gnupg@2.4.0"
  ];
  homebrew.casks = [
#    "intellij-idea"
#    "firefox"
#    "google-chrome"
    "remarkable"
    "gpt4all"
    "neo4j"
    "drawio"
#    "docker"
    "keymapp"
  ];


  environment.systemPackages = with pkgs; [
    atuin
    awscli2
    azure-cli
    bat
    curl
    direnv
    eza
    fd
    fzf
    jq
#    kafkactl
    ripgrep
#    starship
    tealdeer
    yq
    zoxide

    # emacs29-macport
    # most likely available in brew but no idea how to access it
    python3
    python3Packages.pip
    # not available in brew
    sshpass
    # available in brew but no idea what options this is built with
    (aspellWithDicts (dicts: with dicts; [ de en en-computers ]))
    nil
    nixfmt
#    jdtls-wrapper
#    groovy-language-server
    jnv
    languagetool
    ltex-ls # lsp for languagetool
  ];

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214

  # echo "Registering docker-compose as a docker plugin"
  # mkdir -p ~/.docker/cli-plugins
  # ln -sfn /usr/local/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

  environment.variables = {
    GRAPHVIZ_DOT = "/run/current-system/sw/bin/dot";
    HOMEBREW_NO_ANALYTICS = "1";
  };
}
