{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nixvim.homeModules.nixvim];

  programs.nixvim = {
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
    };

    colorscheme = "kanagawa-wave";

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

    plugins = {
      # ── Icons ───────────────────────────────────────────────────────────────
      web-devicons.enable = true;

      # ── Statusline / Bufferline ──────────────────────────────────────────────
      lualine = {
        enable = true;
        settings.options.theme = "kanagawa";
      };
      bufferline.enable = true;

      # ── Snacks ──────────────────────────────────────────────────────────────
      # Ersetzt: telescope, neo-tree, alpha, indent-blankline,
      #          illuminate, toggleterm, nvim-notify (Popups)
      # NICHT ersetzt: noice, gitsigns, which-key, trouble, flash, mini.ai
      snacks = {
        enable = true;
        settings = {
          picker = {
            enabled = true;
            sources = {
              files.hidden = true;
              grep.hidden = true;
            };
          };
          explorer = {enabled = true;};
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

      # ── Noice (LazyVim behält es trotz snacks!) ──────────────────────────────
      # noice: Cmdline-UI, Search-UI, LSP-Progress, Message-Routing
      # snacks.notifier: nur Popup-Notifications
      # Beide zusammen = volle LazyVim-UI-Erfahrung
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                any = [
                  {find = "%d+L, %d+B";}
                  {find = "; after #%d+";}
                  {find = "; before #%d+";}
                ];
              };
              view = "mini";
            }
          ];
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
          };
        };
      };

      # ── Git ──────────────────────────────────────────────────────────────────
      # gitsigns bleibt! Zeigt +/~/- im Gutter – snacks.git ersetzt das nicht
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
        };
      };
      diffview.enable = true;
      neogit = {
        enable = true;
        settings.integrations.diffview = true;
      };

      # ── Navigation ───────────────────────────────────────────────────────────
      # flash.nvim (LazyVim-Standard) statt hop/leap
      flash.enable = true;

      # ── Editing ──────────────────────────────────────────────────────────────
      vim-surround.enable = true;
      comment.enable = true;
      which-key = {
        enable = true;
        settings = {
          preset = "classic";
          win = {
            width.max = 45;
            height = {
              min = 4;
              max = 25;
            };
            col = 1.0;
            row = 0.5;
            border = "rounded";
          };
          layout.align = "right";
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "buffer";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "diagnostics";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "find/files";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "git";
            }
            {
              __unkeyed-1 = "<leader>gh";
              group = "hunks";
            }
            {
              __unkeyed-1 = "<leader>o";
              group = "overseer/scratch";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "quit/session";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "search";
            }
            {
              __unkeyed-1 = "<leader>sn";
              group = "noice";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "ui/toggle";
            }
            {
              __unkeyed-1 = "<leader>z";
              group = "zettelkasten";
            }
            {
              __unkeyed-1 = "<leader>zn";
              group = "new note";
            }
            {
              __unkeyed-1 = "<leader>zo";
              group = "open/browse";
            }
            {
              __unkeyed-1 = "<leader>dt";
              desc = "Diagnostics (Trouble)";
            }
            {
              __unkeyed-1 = "<leader>st";
              desc = "TODOs (Trouble)";
            }
          ];
        };
      };

      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          enable_check_bracket_line = false;
          fast_wrap = {
            enable = true;
            map = "<M-e>";
            chars = ["{" "[" "(" "\"" "'" "`"];
          };
        };
      };

      # mini.ai: erweiterte Text-Objects (LazyVim-Standard)
      mini = {
        enable = true;
        modules.ai = {};
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
            immediate_save = ["BufLeave" "FocusLost"];
            defer_save = ["InsertLeave" "TextChanged"];
            cancel_deferred_save = ["InsertEnter"];
          };
          condition = null;
          write_all_buffers = false;
          debounce_delay = 1000;
        };
      };

      # ── Treesitter ───────────────────────────────────────────────────────────
      treesitter.enable = true;
      treesitter-context.enable = false;

      # ── LSP ──────────────────────────────────────────────────────────────────
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          clangd.enable = true;
          marksman.enable = true;
          hyprls.enable = true;
        };
        keymaps.diagnostic = {
          "<leader>dl" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
      };

      # ── Completion ───────────────────────────────────────────────────────────
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
            "<CR>" = ["accept" "fallback"];
            "<Tab>" = ["select_next" "fallback"];
            "<S-Tab>" = ["select_prev" "fallback"];
          };
          appearance.nerd_font_variant = "mono";
          completion.documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
          };
          sources.default = ["lsp" "path" "snippets" "buffer"];
          snippets.preset = "luasnip";
          fuzzy.implementation = "prefer_rust_with_warning";
          signature.enabled = true;
        };
      };
      luasnip.enable = true;
      friendly-snippets.enable = true;
      lsp-signature.enable = true;

      # ── Formatter ────────────────────────────────────────────────────────────
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = ["alejandra"];
            lua = ["stylua"];
            javascript = ["prettierd"];
            typescript = ["prettierd"];
            javascriptreact = ["prettierd"];
            typescriptreact = ["prettierd"];
            css = ["prettierd"];
            html = ["prettierd"];
            markdown = ["prettierd"];
            sh = ["shfmt"];
          };
          format_on_save.lsp_fallback = true;
        };
      };

      # ── Diagnostics UI ───────────────────────────────────────────────────────
      trouble.enable = true;

      # ── Misc ─────────────────────────────────────────────────────────────────
      colorizer.enable = true;
      markdown-preview.enable = true;
      project-nvim.enable = true;
      lint = {
        enable = true;
        lintersByFt.asciidoc = ["vale"];
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

      # ── Hardtime (schlechte Gewohnheiten abgewöhnen) ──────────────────────────
      hardtime = {
        enable = true;
        settings = {
          enabled = true;
          disable_mouse = false;
          hint = true;
          notification = true;
          max_count = 4; # wie oft man denselben Key hintereinander drücken darf
          restricted_keys = {
            "h" = ["n" "x"];
            "j" = ["n" "x"];
            "k" = ["n" "x"];
            "l" = ["n" "x"];
          };
        };
      };

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
        mode = ["i"];
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }
      {
        key = "<F1>";
        mode = ["n" "i" "v" "x" "s" "o" "t" "c"];
        action = "<Nop>";
        options.desc = "Disable F1";
      }
      {
        key = "<leader>q";
        mode = ["n"];
        action = "<Nop>";
        options = {
          desc = "+quit/session";
          nowait = true;
        };
      }
      {
        key = "<leader>qq";
        mode = ["n"];
        action = "<cmd>qa<cr>";
        options.desc = "Quit all";
      }
      {
        key = "<leader>qs";
        mode = ["n"];
        action = "<cmd>lua require('persistence').load()<cr>";
        options.desc = "Restore Session";
      }
      {
        key = "<leader>qS";
        mode = ["n"];
        action = "<cmd>lua require('persistence').select()<cr>";
        options.desc = "Select Session";
      }
      {
        key = "<leader>ql";
        mode = ["n"];
        action = "<cmd>lua require('persistence').load({ last = true })<cr>";
        options.desc = "Restore Last Session";
      }
      {
        key = "<leader>qd";
        mode = ["n"];
        action = "<cmd>lua require('persistence').stop()<cr>";
        options.desc = "Don't Save Current Session";
      }

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

      # Noice
      {
        key = "<leader>snl";
        action = "<cmd>lua require('noice').cmd('last')<cr>";
        options.desc = "Noice Last Message";
      }
      {
        key = "<leader>snh";
        action = "<cmd>lua require('noice').cmd('history')<cr>";
        options.desc = "Noice History";
      }
      {
        key = "<leader>sna";
        action = "<cmd>lua require('noice').cmd('all')<cr>";
        options.desc = "Noice All";
      }
      {
        key = "<leader>snd";
        action = "<cmd>lua require('noice').cmd('dismiss')<cr>";
        options.desc = "Noice Dismiss";
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

      # ── Flash Navigation ─────────────────────────────────────────────────────
      {
        key = "s";
        mode = ["n" "x" "o"];
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash Jump";
      }
      {
        key = "S";
        mode = ["n" "x" "o"];
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options.desc = "Flash Treesitter";
      }
      {
        key = "r";
        mode = ["o"];
        action = "<cmd>lua require('flash').remote()<cr>";
        options.desc = "Flash Remote";
      }
      {
        key = "R";
        mode = ["o" "x"];
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options.desc = "Flash Treesitter Search";
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

      # ── TODO Comments ────────────────────────────────────────────────────────
      {
        key = "]t";
        action = "<cmd>lua require('todo-comments').jump_next()<cr>";
        options.desc = "Next TODO";
      }
      {
        key = "[t";
        action = "<cmd>lua require('todo-comments').jump_prev()<cr>";
        options.desc = "Prev TODO";
      }
      {
        key = "<leader>st";
        action = "<cmd>TodoTrouble<cr>";
        options.desc = "TODO (Trouble)";
      }

      # ── Comment ──────────────────────────────────────────────────────────────
      {
        key = "<leader>gc";
        mode = ["n"];
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Comment line";
      }
      {
        key = "<leader>gc";
        mode = ["v"];
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Comment selection";
      }

      # ── Diagnostics ──────────────────────────────────────────────────────────
      {
        key = "<leader>dj";
        mode = ["n"];
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }
      {
        key = "<leader>dk";
        mode = ["n"];
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Prev diagnostic";
      }
      {
        key = "<leader>dt";
        mode = ["n"];
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics";
      }

      # ── Help ─────────────────────────────────────────────────────────────────
      {
        key = "<leader>h";
        mode = ["n"];
        action = ":help<Space>";
        options = {
          desc = "Open :help";
          nowait = true;
        };
      }
      {
        key = "<leader>H";
        mode = ["n"];
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

    # ── zk Keymaps (buffer-lokal, nur in Markdown-Dateien im Notebook) ────────
    # Werden in extraConfigLua gesetzt weil sie nur im Notebook-Kontext gelten

    extraPlugins = with pkgs.vimPlugins; [
      zk-nvim
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      bat
      wl-clipboard
      xclip
      lazygit
      zk # zk CLI für zk-nvim
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

    extraConfigLua = ''
      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        update_in_insert = true,
        severity_sort = true,
        underline = true,
        signs = true,
      })

      -- LSP on-attach: nur was nicht via snacks.picker abgedeckt ist
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end
          map("K",          vim.lsp.buf.hover,       "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename,      "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        end,
      })

      -- Snacks Toggles (nach VeryLazy)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell",          { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal" }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })

      -- ── zk Setup & Keymaps ──────────────────────────────────────────────────
      local zk_dir = vim.fn.expand("$HOME/projects/ceickhoff/zettelkasten/personal")

      -- LSP auto-attach mit snacks_picker
      require("zk").setup({
        picker = "snacks_picker",
        lsp = {
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
          auto_attach = { enabled = true },
        },
      })

      -- Helper: neuen Zettel anlegen mit Typ und optionalem Titel
      local function new_zettel(alias, needs_title, title)
        return function()
          local opts = {
            dir = zk_dir .. "/" .. alias,
            template = alias .. ".md",
          }
          if needs_title then
            opts.title = (title and title ~= "") and title or vim.fn.input("Title: ")
          end
          vim.fn.chdir(zk_dir)
          require("zk").new(opts)
        end
      end

      -- Globale zk-Keymaps (überall verfügbar)
      local function gmap(key, fn, desc)
        vim.keymap.set("n", key, fn, { desc = desc })
      end

      gmap("<leader>zo", function() vim.cmd("ZkNotes") end, "Open notes")
      gmap("<leader>zt", function() vim.cmd("ZkTags") end, "Browse tags")
      gmap("<leader>zf", function()
        vim.cmd("ZkNotes { match = { vim.fn.input('Search: ') } }")
      end, "Find notes")

      -- Neue Notiz (generisch)
      gmap("<leader>zn", function()
        vim.fn.chdir(zk_dir)
        local title = vim.fn.input("Note: ")
        if title ~= "" then
          require("zk").new({ title = title })
        end
      end, "New note")

      -- Daily note mit Datumsauswahl
      gmap("<leader>zd", function()
        local today = os.time()
        local day = 24 * 60 * 60
        local options = {
          "Today ("      .. os.date("%Y-%m-%d", today)           .. ")",
          "Yesterday ("  .. os.date("%Y-%m-%d", today - day)     .. ")",
          "Tomorrow ("   .. os.date("%Y-%m-%d", today + day)     .. ")",
          "2 days ago (" .. os.date("%Y-%m-%d", today - 2 * day) .. ")",
          "3 days ago (" .. os.date("%Y-%m-%d", today - 3 * day) .. ")",
          "This Monday (" .. os.date("%Y-%m-%d", today - (os.date("*t").wday - 2) * day) .. ")",
          "Last Monday (" .. os.date("%Y-%m-%d", today - (os.date("*t").wday - 2 + 7) * day) .. ")",
          "Custom date...",
        }
        vim.ui.select(options, { prompt = "Select date for daily note:" }, function(choice)
          local date = choice and choice:match("%((%d%d%d%d%-%d%d%-%d%d)%)")
          if not date then
            date = vim.fn.input("Enter custom date (YYYY-MM-DD): ")
          end
          if date ~= "" then
            new_zettel("daily", true, date)()
          end
        end)
      end, "Daily note")

      -- Strukturierte Notiztypen
      gmap("<leader>zw",  new_zettel("weekly",    false), "Weekly note")
      gmap("<leader>znf", new_zettel("fleeting",  true),  "Fleeting note")
      gmap("<leader>znp", new_zettel("permanent", true),  "Permanent note")
      gmap("<leader>znc", new_zettel("checklist", true),  "New checklist")
      gmap("<leader>zni", new_zettel("idea",      true),  "New idea")
      gmap("<leader>znm", new_zettel("meeting",   true),  "New meeting note")
      gmap("<leader>znr", new_zettel("research",  true),  "New research note")

      -- Browse nach Typ
      gmap("<leader>zoi", function() vim.cmd("ZkNotes { hrefs = { '" .. zk_dir .. "/idea' } }") end,     "Browse ideas")
      gmap("<leader>zom", function() vim.cmd("ZkNotes { hrefs = { '" .. zk_dir .. "/meeting' } }") end,  "Browse meetings")
      gmap("<leader>zoj", function() vim.cmd("ZkNotes { hrefs = { '" .. zk_dir .. "/permanent' } }") end,"Browse permanent")
      gmap("<leader>zor", function() vim.cmd("ZkNotes { hrefs = { '" .. zk_dir .. "/research' } }") end, "Browse research")

      -- Globale Volltext-Suche über alle Notizbücher
      gmap("<leader>zfa", function()
        local term = vim.fn.input("Search all notebooks: ")
        if term ~= "" then
          require("snacks.picker").grep({
            cwd = zk_dir,
            search = term,
          })
        end
      end, "Search all notebooks")

      -- Buffer-lokale Keymaps nur im zk-Notebook
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          if not pcall(require, "zk.util") then return end
          if require("zk.util").notebook_root(vim.fn.expand("%:p")) == nil then return end

          local function bmap(key, cmd, desc, mode)
            vim.keymap.set(mode or "n", key, cmd, { buffer = true, desc = desc })
          end

          bmap("<CR>",         "<Cmd>lua vim.lsp.buf.definition()<CR>",        "Follow link")
          bmap("<leader>zb",   "<Cmd>ZkBacklinks<CR>",                         "Backlinks")
          bmap("<leader>zl",   "<Cmd>ZkLinks<CR>",                             "Links")
          -- Visual mode: Auswahl als neuen Zettel
          bmap("<leader>zl",  ":'<,'>ZkNewFromTitleSelection<CR>",   "Create link from selection", "v")
          bmap("<leader>znt", ":'<,'>ZkNewFromTitleSelection<CR>",   "New note from title sel.",   "v")
          bmap("<leader>znc", ":'<,'>ZkNewFromContentSelection<CR>", "New note from content sel.", "v")
          bmap("<leader>zm",  ":'<,'>ZkMatch<CR>",                   "Find similar notes",         "v")
        end,
      })

      -- OSC52 Clipboard
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
          ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
          ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
          ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
      }
    '';
  };
}
