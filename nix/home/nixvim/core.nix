{...}: {
  programs.nixvim = {

    editorconfig.enable = true;
    enable = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 200;
      cursorline = true;
      spell = true;
      spelllang = ["en" "de"];
      clipboard = "unnamedplus";
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldenable = true;
      foldlevel = 99;
    };

    colorschemes.kanagawa = {
      enable = true;
      autoLoad = true;
      settings = {
        theme = "wave";
        background = {
          dark = "wave";
          light = "lotus";
        };
        overrides = ''
          function(colors)
            local theme = colors.theme
            return {
              DiffAdd    = { bg = theme.diff.add },
              DiffChange = { bg = theme.diff.change },
              DiffDelete = { bg = theme.diff.delete },
              DiffText   = { bg = theme.diff.text },
            }
          end
        '';
      };
    };
  };
}
