{ inputs, config, lib, pkgs, ... }: {
  imports = [
    ./nixvim/asciidoctor.nix
    ./nixvim/autocmd.nix
     ./nixvim/core.nix
    ./nixvim/codecompanion.nix
    ./nixvim/git.nix
    ./nixvim/helm.nix
    # ./nixvim/markmap.nix
    ./nixvim/snacks.nix
    ./nixvim/lsp.nix
    ./nixvim/latex.nix
    ./nixvim/noice.nix
    ./nixvim/obsidian.nix
    ./nixvim/outline.nix
    ./nixvim/writing.nix
    ./nixvim/todo.nix
    ./nixvim/search.nix
    ./nixvim/treesitter.nix
    ./nixvim/whichkey.nix
  ];

  programs.nixvim = {
    plugins = {
      direnv.enable = true;
      # ── Icons ───────────────────────────────────────────────────────────────
      web-devicons.enable = true;

      # ── Statusline / Bufferline ──────────────────────────────────────────────
      lualine = {
        enable = true;
        settings.options.theme = "kanagawa";
      };
      bufferline.enable = true;

      # ── Git ──────────────────────────────────────────────────────────────────

      # ── Navigation ───────────────────────────────────────────────────────────
      # flash.nvim (LazyVim-Standard) statt hop/leap
      flash.enable = true;

      # ── Editing ──────────────────────────────────────────────────────────────
      vim-surround.enable = true;
      comment.enable = true;
      typescript-tools.enable = true;

      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          enable_check_bracket_line = false;
          fast_wrap = {
            enable = true;
            map = "<M-e>";
            chars = [ "{" "[" "(" ''"'' "'" "`" ];
          };
        };
      };

      # mini.ai: erweiterte Text-Objects (LazyVim-Standard)
      mini = {
        enable = true;
        modules.ai = { };
      };

      # ── Session Management ────────────────────────────────────────────────────
      persistence = {
        enable = true;
        settings.dir = "${config.xdg.dataHome}/nvim/sessions/";
      };
      auto-save = {
        enable = true;
        settings = {
          enabled = true;
          trigger_events = {
            immediate_save = [ "BufLeave" "FocusLost" ];
            defer_save = [ "InsertLeave" "TextChanged" ];
            cancel_deferred_save = [ "InsertEnter" ];
          };
          condition = null;
          write_all_buffers = false;
          debounce_delay = 1000;
        };
      };

      # ── Treesitter ───────────────────────────────────────────────────────────
      treesitter.enable = true;
      treesitter-context.enable = false;

      # ── Completion ───────────────────────────────────────────────────────────
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
            "<CR>" = [ "accept" "fallback" ];
            "<Tab>" = [ "select_next" "fallback" ];
            "<S-Tab>" = [ "select_prev" "fallback" ];
          };
          appearance.nerd_font_variant = "mono";
          completion.documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
          };
          sources.default = [ "lsp" "path" "snippets" "buffer" ];
          snippets.preset = "luasnip";
          fuzzy.implementation = "prefer_rust_with_warning";
          signature.enabled = true;
        };
      };
      luasnip.enable = true;
      friendly-snippets.enable = true;
      lsp-signature.enable = true;

      # ── Diagnostics UI ───────────────────────────────────────────────────────
      trouble.enable = true;

      # ── Misc ─────────────────────────────────────────────────────────────────
      colorizer.enable = true;
      markdown-preview.enable = true;
      project-nvim.enable = true;
      lint = {
        enable = true;
        lintersByFt.asciidoc = [ "vale" ];
      };

      # ── Overseer (Task Runner) ────────────────────────────────────────────────
      overseer = {
        enable = true;
        settings = {
          task_list = {
            direction = "bottom";
            min_height = 10;
          };
        };
      };

      # ── zk-nvim (Zettelkasten) ────────────────────────────────────────────────
      # Kein natives NixVim-Modul – wird über extraPlugins eingebunden
      # Konfiguration erfolgt in extraConfigLua

      # ── img-clip (Bilder in Buffer einfügen) ──────────────────────────────────
      img-clip = {
        enable = true;
        settings = {
          default = {
            dir_path = "assets"; # relativ zur aktuellen Datei
            file_name = "%Y-%m-%d-%H-%M-%S";
            use_absolute_path = false;
            relative_to_current_file = true;
            prompt_for_file_name = false;
          };
        };
      };
    };

    # ── Keymaps ───────────────────────────────────────────────────────────────
    keymaps = [
      # ── Allgemein ───────────────────────────────────────────────────────────
      {
        key = "jk";
        mode = [ "i" ];
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }
      {
        key = "<F1>";
        mode = [ "n" "i" "v" "x" "s" "o" "t" "c" ];
        action = "<Nop>";
        options.desc = "Disable F1";
      }
      {
        key = "<leader>q";
        mode = [ "n" ];
        action = "<Nop>";
        options = {
          desc = "+quit/session";
          nowait = true;
        };
      }
      {
        key = "<leader>qq";
        mode = [ "n" ];
        action = "<cmd>qa<cr>";
        options.desc = "Quit all";
      }
      {
        key = "<leader>qs";
        mode = [ "n" ];
        action = "<cmd>lua require('persistence').load()<cr>";
        options.desc = "Restore Session";
      }
      {
        key = "<leader>qS";
        mode = [ "n" ];
        action = "<cmd>lua require('persistence').select()<cr>";
        options.desc = "Select Session";
      }
      {
        key = "<leader>ql";
        mode = [ "n" ];
        action = "<cmd>lua require('persistence').load({ last = true })<cr>";
        options.desc = "Restore Last Session";
      }
      {
        key = "<leader>qd";
        mode = [ "n" ];
        action = "<cmd>lua require('persistence').stop()<cr>";
        options.desc = "Don't Save Current Session";
      }

      # Gitsigns Hunks
      {
        key = "]h";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options.desc = "Next Hunk";
      }
      {
        key = "[h";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options.desc = "Prev Hunk";
      }
      {
        key = "<leader>ghs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        options.desc = "Stage Hunk";
      }
      {
        key = "<leader>ghr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        options.desc = "Reset Hunk";
      }
      {
        key = "<leader>ghp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options.desc = "Preview Hunk";
      }
      {
        key = "<leader>ghb";
        action = "<cmd>Gitsigns blame_line<cr>";
        options.desc = "Blame Line";
      }

      # ── Flash Navigation ─────────────────────────────────────────────────────
      {
        key = "s";
        mode = [ "n" "x" "o" ];
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash Jump";
      }
      {
        key = "S";
        mode = [ "n" "x" "o" ];
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options.desc = "Flash Treesitter";
      }
      {
        key = "r";
        mode = [ "o" ];
        action = "<cmd>lua require('flash').remote()<cr>";
        options.desc = "Flash Remote";
      }
      {
        key = "R";
        mode = [ "o" "x" ];
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options.desc = "Flash Treesitter Search";
      }

      # ── Buffer Navigation ────────────────────────────────────────────────────
      {
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Prev Buffer";
      }
      {
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next Buffer";
      }
      {
        key = "]b";
        action = "<cmd>bnext<cr>";
        options.desc = "Next Buffer";
      }
      {
        key = "[b";
        action = "<cmd>bprevious<cr>";
        options.desc = "Prev Buffer";
      }
      {
        key = "<leader>bp";
        action = "<cmd>lua require('bufferline').toggle_pin()<cr>";
        options.desc = "Pin Buffer";
      }
      {
        key = "<leader>bP";
        action = "<cmd>lua require('bufferline').group_close('ungrouped')<cr>";
        options.desc = "Close Unpinned Buffers";
      }

      {
        key = "<leader>st";
        action = "<cmd>TodoTrouble<cr>";
        options.desc = "TODO (Trouble)";
      }

      # ── Comment ──────────────────────────────────────────────────────────────
      {
        key = "<leader>gc";
        mode = [ "n" ];
        action =
          "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Comment line";
      }
      {
        key = "<leader>gc";
        mode = [ "v" ];
        action =
          "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Comment selection";
      }

      # ── Diagnostics ──────────────────────────────────────────────────────────
      {
        key = "<leader>dj";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        key = "<leader>dk";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Prev diagnostic";
      }
      {
        key = "<leader>dt";
        mode = [ "n" ];
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics";
      }

      # ── Help ─────────────────────────────────────────────────────────────────
      {
        key = "<leader>h";
        mode = [ "n" ];
        action = ":help<Space>";
        options = {
          desc = "Open :help";
          nowait = true;
        };
      }
      {
        key = "<leader>H";
        mode = [ "n" ];
        action = ":help <C-r><C-w><CR>";
        options.desc = "Help for word under cursor";
      }

      # ── Overseer ─────────────────────────────────────────────────────────────
      {
        key = "<leader>ot";
        action = "<cmd>OverseerToggle<cr>";
        options.desc = "Task List";
      }
      {
        key = "<leader>or";
        action = "<cmd>OverseerRun<cr>";
        options.desc = "Run Task";
      }
      {
        key = "<leader>oo";
        action = "<cmd>OverseerOpen<cr>";
        options.desc = "Open Overseer";
      }

      # ── img-clip ─────────────────────────────────────────────────────────────
      {
        key = "<leader>ip";
        action = "<cmd>PasteImage<cr>";
        options.desc = "Paste Image";
      }

      # ── Hardtime (Toggle) ────────────────────────────────────────────────────
      {
        key = "<leader>oh";
        action = "<cmd>Hardtime toggle<cr>";
        options.desc = "Toggle Hardtime";
      }
    ];

    extraPackages = with pkgs; [
      tree-sitter
      nodejs
      ripgrep
      fd
      bat
      lazygit
      nil
      hyprls
      nodePackages.typescript-language-server
      nodePackages.typescript
      vscode-langservers-extracted
      pyright
      lua-language-server
      zls
      marksman
      multimarkdown
      clang-tools
      prettierd
      stylua
      shfmt
      nixpkgs-fmt
    ];
  };
}
