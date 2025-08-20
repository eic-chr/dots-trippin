{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true; # Wichtig!
    initExtra = lib.readFile ./initExtra.sh;

    historySubstringSearch.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "brew" # Homebrew completion
        "docker" # Docker completion
        "kubectl" # Falls du Kubernetes nutzt
        "macos" # macOS spezifische Aliase
        "ssh"
        "z" # Jump to directories
        "git"
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = ["--height 40%" "--layout=reverse" "--border"];
  };
  # AKTIVIERE das!
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
