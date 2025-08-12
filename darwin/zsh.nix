{ programs, lib, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;  # Wichtig!
    initExtra = lib.readFile ./initExtra.sh;

# Bessere History
      historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
          "macos"        # macOS spezifische Aliase
          "brew"         # Homebrew completion
          "docker"       # Docker completion
          "kubectl"      # Falls du Kubernetes nutzt
          "z"            # Jump to directories
      ];
    };

    shellAliases = {
# Deine bestehenden...
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree --level=2";

# Git shortcuts
      g = "git";
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

# System
      top = "htop";
      ps = "procs";
      du = "dust";

# Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "~" = "cd ~";
    };
  };

# AKTIVIERE das!
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../starship/starship.toml);
  };
                              }
