# VSCode Konfiguration mit Vim-Integration
{
  pkgs,
  hasPlasma ? false,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # Extensions
    extensions = with pkgs.vscode-extensions; [
      # Vim Integration

      # Git
      eamodio.gitlens

      # Languages & Formatters
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      bradlc.vscode-tailwindcss
      ms-python.python
      ms-python.pylint
      rust-lang.rust-analyzer

      # AsciiDoc
      asciidoctor.asciidoctor-vscode

      # Themes & UI
      github.github-vscode-theme
      pkief.material-icon-theme

      # Utilities
      ms-vsliveshare.vsliveshare
      ms-vscode.hexeditor
      redhat.vscode-yaml
      tamasfe.even-better-toml

      # Docker & Containers
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker

      # Nix Support
      bbenoist.nix
      jnoortheen.nix-ide
    ];
    # Entferne den problematischen marketplace-Block erstmal

    # VSCode Settings
    userSettings =
      {
        # Editor Settings
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'MesloLGS NF', 'Fira Code', monospace";
        "editor.fontLigatures" = true;
        "editor.lineNumbers" = "relative";
        "editor.cursorBlinking" = "solid";
        "editor.scrollBeyondLastLine" = false;
        "editor.wordWrap" = "bounded";
        "editor.rulers" = [80 120];
        "editor.minimap.enabled" = false;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

        # Workbench
        "workbench.colorTheme" = "GitHub Dark Default";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "workbench.editor.showTabs" = "multiple";
        "workbench.activityBar.location" = "top";

        # Terminal
        "terminal.integrated.fontSize" = 14;
        "terminal.integrated.fontFamily" = "'MesloLGS NF', monospace";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.profiles.linux" = {
          "zsh" = {"path" = "${pkgs.zsh}/bin/zsh";};
        };

        # Git
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "git.autofetch" = true;

        # GitLens
        "gitlens.codeLens.enabled" = false;
        "gitlens.currentLine.enabled" = false;
        "gitlens.hovers.currentLine.over" = "line";
        "gitlens.blame.format" = "\${author} • \${date} • \${message}";

        # Language-specific settings
        "eslint.workingDirectories" = ["client" "server"];
        "prettier.requireConfig" = true;
        "prettier.useEditorConfig" = false;

        # Python
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";
        "python.formatting.provider" = "black";
        "python.linting.enabled" = true;
        "python.linting.pylintEnabled" = true;

        # AsciiDoc
        "asciidoc.preview.doubleClickToSwitchTab" = false;
        "asciidoc.preview.scrollPreviewWithEditor" = true;
        "asciidoc.preview.markEditorSelection" = true;

        # File associations
        "files.associations" = {
          "*.nix" = "nix";
          "justfile" = "makefile";
          "Justfile" = "makefile";
        };

        # Explorer
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        # Search
        "search.exclude" = {
          "**/node_modules" = true;
          "**/target" = true;
          "**/.git" = true;
          "**/dist" = true;
          "**/build" = true;
        };

        # Platform-specific settings
      }
      // (
        if hasPlasma
        then {
          # Linux-specific settings
          "window.titleBarStyle" = "custom";
          "window.menuBarVisibility" = "toggle";
        }
        else {
          # macOS-specific settings
          "window.titleBarStyle" = "custom";
        }
      );

    # Keybindings (zusätzlich zu Vim-Mappings)
    keybindings = [
      # Terminal shortcuts
      {
        "key" =
          if hasPlasma
          then "ctrl+shift+`"
          else "cmd+shift+`";
        "command" = "workbench.action.terminal.toggleTerminal";
      }

      # Quick file switching
      {
        "key" =
          if hasPlasma
          then "ctrl+p"
          else "cmd+p";
        "command" = "workbench.action.quickOpen";
      }

      # Command palette
      {
        "key" =
          if hasPlasma
          then "ctrl+shift+p"
          else "cmd+shift+p";
        "command" = "workbench.action.showCommands";
      }

      # Disable default vim conflicting shortcuts
      {
        "key" = "ctrl+d";
        "command" = "-editor.action.addSelectionToNextFindMatch";
        "when" = "editorFocus && vim.active";
      }
      {
        "key" = "ctrl+f";
        "command" = "-actions.find";
        "when" = "editorFocus && vim.active";
      }
    ];
  };

  # Install zusätzliche Tools die VSCode Extensions benötigen
  home.packages = with pkgs; [
    # Language Servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nixd # Moderner Nix Language Server (ersetzt rnix-lsp)

    # Formatters & Linters
    nodePackages.prettier
    nodePackages.eslint
    black # Python formatter

    # Git tools
    git
    gh # GitHub CLI

    # AsciiDoc tools
    asciidoctor

    # Other useful tools
    ripgrep # Fast grep for VSCode search
    fd # Fast find alternative
  ];
}
