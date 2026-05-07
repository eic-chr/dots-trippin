{pkgs,...}: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight = { enable = true; };
        indent = { enable = true; };    # Unter settings!
          fold = { enable = true; };      # "folding" → "fold"
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        helm
          json
          latex
          lua
          markdown
          nix
          regex
          toml
          typescript
          terraform
          hcl
          vim
          vimdoc
          yaml
      ];
    };
  };
            }
