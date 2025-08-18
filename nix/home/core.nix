{pkgs, ...}: {
home.packages = with pkgs; [
    # Archives
    zip
    xz
    unzip
    p7zip
    
    # System utilities (von Ihrer system-Liste)
    bat              # cat-Ersatz
    dust             # du-Ersatz  
    eza              # ls-Ersatz
    fd               # find-Ersatz
    tealdeer         # tldr
    zoxide           # cd-Ersatz
    
    # Search & text processing
    ripgrep          # recursively searches directories for a regex pattern
    jq               # A lightweight and flexible command-line JSON processor
    yq-go            # yaml processer (besser als yq)
    fzf              # A command-line fuzzy finder
    
    # Development tools (von Ihrer system-Liste)
    cargo
    lazygit          # Git-UI
    nil              # Nix LSP
    nixfmt           # Nix-Formatter
    nodejs
    marksman         # Markdown LSP
    python3          # Entwicklungsumgebung
    # python3Packages.pip
    jnv              # JSON-Viewer
    
    # Network & download
    aria2            # A lightweight multi-protocol & multi-source command-line download utility
    socat            # replacement of openbsd-netcat
    nmap             # A utility for network discovery and security auditing
    caddy            # Web server
    
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
    glow             # markdown previewer in terminal
    atuin            # Shell-History
    languagetool     # Sprachprüfung
    ltex-ls          # LSP für LanguageTool
    zk               # Zettelkasten
    
    # Fun
    cowsay
    
    # Terminal (falls Sie es nicht systemweit wollen)
    # kitty          # Auskommentiert - könnte auch system-wide bleiben
];

  programs = {
    direnv.enable = true;
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
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
