{pkgs, ...}: {
  home.packages = with pkgs; [
    # Archives
    zip
    xz
    unzip
    p7zip

    # System utilities (von Ihrer system-Liste)
    bat # cat-Ersatz
    dust # du-Ersatz
    eza # ls-Ersatz
    fd # find-Ersatz
    tealdeer # tldr
    zoxide # cd-Ersatz

    # Multimedia
    imagemagick
    exiftool

    # Search & text processing
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer (besser als yq)
    fzf # A command-line fuzzy finder

    # Development tools (von Ihrer system-Liste)
    jdk21
    cargo
    lazygit # Git-UI
    vale # Docs Linter
    nil # Nix LSP
    nixfmt-classic # Nix-Formatter
    nodejs
    marksman # Markdown LSP
    python3 # Entwicklungsumgebung
    # python3Packages.pip
    jnv # JSON-Viewer

    # Network & download
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # System info & utilities
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # Productivity
    atuin # Shell-History
    languagetool # Sprachprüfung
    ltex-ls-plus # LSP für LanguageTool
    zk # Zettelkasten

    # Terminal (falls Sie es nicht systemweit wollen)
  ];

  programs = {
    nix-index.enable = true;
    direnv.enable = true;
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };
    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
