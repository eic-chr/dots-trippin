{pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      texlab        # LSP
        zathura       # falls doch mal gebraucht
    ];

# ── Treesitter ─────────────────────────────────────────────────────────────
    plugins.treesitter.settings.ensure_installed = [ "latex" "bibtex" ];

# ── LSP: texlab ────────────────────────────────────────────────────────────
    plugins.lsp.servers.texlab = {
      enable = true;
      settings = {
        texlab = {
          build = {
            executable = "latexmk";
            args = [ "-pdf" "-interaction=nonstopmode" "-synctex=1" "%f" ];
            onSave = true;
            forwardSearchAfter = true;
          };
          forwardSearch = {
            executable = "zathura";
            args = [ "--unique" "file:%p#src:%l%f" ];
          };
          chktex = {
            onOpenAndSave = true;
            onEdit = false;
          };
          latexindent = {
            modifyLineBreaks = false;
          };
        };
      };
    };

# ── vimtex ─────────────────────────────────────────────────────────────────
    plugins.vimtex = {
      enable = true;
      settings = {
        view_method = "zathura";
        view_zathura_hook_view = "";  # deaktiviert den xdotool-Hook
        compiler_method = "latexmk";
        compiler_latexmk = {
          aux_dir = ".aux";
          out_dir = ".out";
          options = [
            "-pdf"
              "-shell-escape"
              "-verbose"
              "-file-line-error"
              "-synctex=1"
              "-interaction=nonstopmode"
          ];
        };
      };
    };

# ── blink.cmp – vimtex Quelle einbinden ────────────────────────────────────
    plugins.blink-cmp.settings.sources.providers = {
      vimtex = {
        name = "vimtex";
        module = "blink.compat.source";
        score_offset = 5;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      blink-compat   # Brücke für nvim-cmp-kompatible Sources
        cmp-vimtex     # vimtex Completion-Source
    ];

# ── Keymaps ────────────────────────────────────────────────────────────────
    keymaps = [
    {
      key = "<localleader>ll";
      action = "<cmd>VimtexCompile<cr>";
      options.desc = "LaTeX Kompilieren (Toggle)";
    }
    {
      key = "<localleader>lv";
      action = "<cmd>VimtexView<cr>";
      options.desc = "PDF anzeigen (Okular)";
    }
    {
      key = "<localleader>le";
      action = "<cmd>VimtexErrors<cr>";
      options.desc = "Fehler anzeigen";
    }
    {
      key = "<localleader>lc";
      action = "<cmd>VimtexClean<cr>";
      options.desc = "Aux-Dateien aufräumen";
    }
    {
      key = "<localleader>lt";
      action = "<cmd>VimtexTocToggle<cr>";
      options.desc = "Inhaltsverzeichnis";
    }
    ];

# ── Autocmd: Einstellungen nur für .tex Dateien ────────────────────────────
    autoCmd = [
    {
      event = "FileType";
      pattern = "tex";
      desc = "LaTeX-spezifische Einstellungen";
      callback = {
        __raw = ''
          function()
          vim.opt_local.textwidth = 100
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "de,en"
          vim.opt_local.conceallevel = 2
          end
          '';
      };
    }
    ];
  };
}
