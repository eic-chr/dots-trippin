{...}: {
  programs.nixvim = {
    plugins.snacks = {
      # ── Snacks ──────────────────────────────────────────────────────────────
      # Ersetzt: telescope, neo-tree, alpha, indent-blankline,
      #          illuminate, toggleterm, nvim-notify (Popups)
      # NICHT ersetzt: noice, gitsigns, which-key, trouble, flash, mini.ai
      enable = true;
      settings = {
        picker = {
          enabled = true;
          sources = {
            files.hidden = true;
            grep.hidden = true;
            explorer.ignored = true;
          };
        };
        explorer = {
          enabled = true;
          hidden = true;
        };
        dashboard = {
          enabled = true;
          preset = {
            header = ''
              ███████╗██╗    ██╗ ██████╗ ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
              ██╔════╝██║    ██║██╔═══██╗████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
              █████╗  ██║ █╗ ██║██║   ██║██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
              ██╔══╝  ██║███╗██║██║   ██║██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
              ███████╗╚███╔███╔╝╚██████╔╝██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
            '';
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.picker.files()";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.picker.recent()";
              }
              {
                icon = " ";
                key = "g";
                desc = "Live Grep";
                action = ":lua Snacks.picker.grep()";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":enew";
              }
              {
                icon = " ";
                key = "e";
                desc = "Explorer";
                action = ":lua Snacks.explorer()";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };
          sections = [
            {section = "header";}
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
          ];
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        terminal = {enabled = true;};
        indent = {enabled = true;};
        words = {enabled = true;};
        scroll = {enabled = true;};
        input = {enabled = true;};
        bigfile = {enabled = true;};
        quickfile = {enabled = true;};
        statuscolumn = {enabled = true;};
        zen = {enabled = true;};
        scratch = {enabled = true;};
        bufdelete = {enabled = true;};
        rename = {enabled = true;};
        gitbrowse = {enabled = true;};
        lazygit = {enabled = true;};
        git = {enabled = true;};
      };
    };

    keymaps = [
      # ── Snacks Picker ───────────────────────────────────────────────────────
      {
        key = "<leader><space>";
        action = "<cmd>lua Snacks.picker.smart()<cr>";
        options.desc = "Smart Find Files";
      }
      {
        key = "<leader>,";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        key = "<leader>/";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep";
      }
      {
        key = "<leader>:";
        action = "<cmd>lua Snacks.picker.command_history()<cr>";
        options.desc = "Command History";
      }
      # Find
      {
        key = "<leader>ff";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        options.desc = "Find Files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>lua Snacks.picker.git_files()<cr>";
        options.desc = "Git Files";
      }
      {
        key = "<leader>fr";
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        options.desc = "Recent Files";
      }
      {
        key = "<leader>fb";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        options.desc = "Buffers";
      }
      {
        key = "<leader>fc";
        action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>";
        options.desc = "Find Config File";
      }
      {
        key = "<leader>fp";
        action = "<cmd>lua Snacks.picker.projects()<cr>";
        options.desc = "Projects";
      }

      # Grep / Search
      {
        key = "<leader>sg";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep";
      }
      {
        key = "<leader>sw";
        action = "<cmd>lua Snacks.picker.grep_word()<cr>";
        options.desc = "Grep Word";
        mode = ["n" "x"];
      }
      {
        key = "<leader>sb";
        action = "<cmd>lua Snacks.picker.lines()<cr>";
        options.desc = "Buffer Lines";
      }
      {
        key = "<leader>sB";
        action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
        options.desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sh";
        action = "<cmd>lua Snacks.picker.help()<cr>";
        options.desc = "Help Pages";
      }
      {
        key = "<leader>sk";
        action = "<cmd>lua Snacks.picker.keymaps()<cr>";
        options.desc = "Keymaps";
      }
      {
        key = "<leader>sd";
        action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
        options.desc = "Diagnostics";
      }
      {
        key = "<leader>sD";
        action = "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>";
        options.desc = "Buffer Diagnostics";
      }
      {
        key = "<leader>sj";
        action = "<cmd>lua Snacks.picker.jumps()<cr>";
        options.desc = "Jumps";
      }
      {
        key = "<leader>sm";
        action = "<cmd>lua Snacks.picker.marks()<cr>";
        options.desc = "Marks";
      }
      {
        key = "<leader>sR";
        action = "<cmd>lua Snacks.picker.resume()<cr>";
        options.desc = "Resume";
      }
      {
        key = "<leader>su";
        action = "<cmd>lua Snacks.picker.undo()<cr>";
        options.desc = "Undo History";
      }
      {
        key = "<leader>uC";
        action = "<cmd>lua Snacks.picker.colorschemes()<cr>";
        options.desc = "Colorschemes";
      }
      # ── Explorer ────────────────────────────────────────────────────────────
      {
        key = "<leader>e";
        action = "<cmd>lua Snacks.explorer()<cr>";
        options.desc = "File Explorer";
      }

      # ── LSP via Snacks Picker ────────────────────────────────────────────────
      {
        key = "gd";
        action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
        options.desc = "Goto Definition";
      }
      {
        key = "gD";
        action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
        options.desc = "Goto Declaration";
      }
      {
        key = "gr";
        action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
        options.desc = "References";
        options.nowait = true;
      }
      {
        key = "gI";
        action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
        options.desc = "Goto Implementation";
      }
      {
        key = "gy";
        action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
        options.desc = "Goto Type Definition";
      }
      {
        key = "<leader>ss";
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        options.desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
        options.desc = "LSP Workspace Symbols";
      }
      # ── Git ─────────────────────────────────────────────────────────────────
      {
        key = "<leader>gg";
        action = "<cmd>lua Snacks.lazygit()<cr>";
        options.desc = "Lazygit";
      }
      {
        key = "<leader>gn";
        action = "<cmd>Neogit<cr>";
        options.desc = "Neogit";
      }
      {
        key = "<leader>gl";
        action = "<cmd>lua Snacks.picker.git_log()<cr>";
        options.desc = "Git Log";
      }
      {
        key = "<leader>gL";
        action = "<cmd>lua Snacks.picker.git_log_line()<cr>";
        options.desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        action = "<cmd>lua Snacks.picker.git_status()<cr>";
        options.desc = "Git Status";
      }
      {
        key = "<leader>gS";
        action = "<cmd>lua Snacks.picker.git_stash()<cr>";
        options.desc = "Git Stash";
      }
      {
        key = "<leader>gb";
        action = "<cmd>lua Snacks.picker.git_branches()<cr>";
        options.desc = "Git Branches";
      }
      {
        key = "<leader>gd";
        action = "<cmd>lua Snacks.picker.git_diff()<cr>";
        options.desc = "Git Diff";
      }
      {
        key = "<leader>gf";
        action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
        options.desc = "Git Log File";
      }
      {
        key = "<leader>gB";
        action = "<cmd>lua Snacks.gitbrowse()<cr>";
        options.desc = "Git Browse";
        mode = ["n" "v"];
      }
      # ── Notifications ───────────────────────────────────────────────────────
      {
        key = "<leader>un";
        action = "<cmd>lua Snacks.notifier.hide()<cr>";
        options.desc = "Dismiss Notifications";
      }
      {
        key = "<leader>uN";
        action = "<cmd>lua Snacks.notifier.show_history()<cr>";
        options.desc = "Notification History";
      }

      # ── Zen / Zoom ──────────────────────────────────────────────────────────
      {
        key = "<leader>uz";
        action = "<cmd>lua Snacks.zen()<cr>";
        options.desc = "Zen Mode";
      }
      {
        key = "<leader>uZ";
        action = "<cmd>lua Snacks.zen.zoom()<cr>";
        options.desc = "Zoom";
      }

      # ── Terminal ────────────────────────────────────────────────────────────
      {
        key = "<c-/>";
        action = "<cmd>lua Snacks.terminal()<cr>";
        options.desc = "Toggle Terminal";
      }
      {
        key = "<leader>t";
        action = "<cmd>lua Snacks.terminal()<cr>";
        options.desc = "Toggle Terminal";
      }
      # Terminal-Mode verlassen ohne <C-\><C-n>
      {
        key = "<Esc><Esc>";
        mode = ["t"];
        action = "<C-\\><C-n>";
        options.desc = "Exit Terminal Mode";
      }
      {
        key = "<C-/>";
        mode = ["t"];
        action = "<cmd>lua Snacks.terminal()<cr>";
        options.desc = "Hide Terminal";
      }
      # ── Scratch ─────────────────────────────────────────────────────────────
      {
        key = "<leader>os";
        action = "<cmd>lua Snacks.scratch()<cr>";
        options.desc = "Scratch Buffer";
      }
      {
        key = "<leader>oS";
        action = "<cmd>lua Snacks.scratch.select()<cr>";
        options.desc = "Select Scratch Buffer";
      }
      # ── Buffer ──────────────────────────────────────────────────────────────
      {
        key = "<leader>bd";
        action = "<cmd>lua Snacks.bufdelete()<cr>";
        options.desc = "Delete Buffer";
      }
      {
        key = "<leader>cR";
        action = "<cmd>lua Snacks.rename.rename_file()<cr>";
        options.desc = "Rename File";
      }
      # ── Wort-Navigation ──────────────────────────────────────────────────────
      {
        key = "]]";
        action = "<cmd>lua Snacks.words.jump(vim.v.count1)<cr>";
        options.desc = "Next Reference";
        mode = ["n" "t"];
      }
      {
        key = "[[";
        action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<cr>";
        options.desc = "Prev Reference";
        mode = ["n" "t"];
      }
    ];
  };
}
