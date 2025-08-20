# vars/packages.nix
{
  # Base packages für alle
  base = {
    system = ["curl" "wget" "git" "vim" "htop" "tree"];
    home = ["firefox" "thunderbird"];
  };

  # Developer Role
  developer = {
    system = ["docker" "podman" "git" "vim" "curl" "wget"];
    home = [
      "vscode"
      "nodejs"
      "python3"
      "postman"
      "dbeaver-bin"
      "docker-compose"
    ];
    shellAliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      nr = "nix run";
      ns = "nix shell";
      nd = "nix develop";
    };
    systemGroups = ["wheel" "docker"];
  };

  # Office Role
  office = {
    system = ["firefox" "thunderbird"];
    home = [
      "libreoffice"
      "teams-for-linux"
      "zoom-us"
      "slack"
      "obsidian"
    ];
    shellAliases = {
      work = "cd ~/Documents/Work";
      docs = "cd ~/Documents";
      mail = "thunderbird";
    };
    systemGroups = [];
  };

  # Gamer Role
  gamer = {
    system = ["steam" "discord"];
    home = [
      "obs-studio"
      "gimp"
      "vlc"
      "spotify"
      "lutris"
    ];
    shellAliases = {
      gaming = "cd ~/Games";
      steam-run = "steam-run";
    };
    systemGroups = [];
  };

  # Student Role
  student = {
    system = ["firefox" "libreoffice"];
    home = [
      "obsidian"
      "zotero"
      "gimp"
      "vlc"
      "anki"
    ];
    shellAliases = {
      study = "cd ~/Studies";
      notes = "cd ~/Notes";
    };
    systemGroups = [];
  };
}
