{pkgs, ...}: {
  programs.nixvim = {
    enable = true;

    # =========================================================
    # Allgemeine Einstellungen
    # =========================================================
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      splitright = true;
      splitbelow = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # =========================================================
    # Theme
    # =========================================================
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

    # =========================================================
    # Keymaps
    # =========================================================
    keymaps = [
      # Fensterwechsel
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }

      # Buffer navigieren
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprev<CR>";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
      }

      # Indentation im Visual Mode beibehalten
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      # Zeilen verschieben
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<CR>gv=gv";
      }

      # Speichern / Beenden
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bd<CR>";
        options.desc = "Delete Buffer";
      }

      # Neo-tree
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Neotree focus<CR>";
        options.desc = "Focus Explorer";
      }

      # Formatting
      {
        mode = ["n" "v"];
        key = "<leader>lf";
        action.__raw = ''
          function() require("conform").format({ async = true, lsp_fallback = true }) end
        '';
        options.desc = "Format";
      }

      # Diagnostics
      {
        mode = "n";
        key = "<leader>cd";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Line Diagnostics";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Prev Diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next Diagnostic";
      }

      # Snacks Picker
      {
        mode = "n";
        key = "<leader><space>";
        action.__raw = ''function() Snacks.picker.files({ hidden = true }) end'';
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = ''function() Snacks.picker.grep({ hidden = true }) end'';
        options.desc = "Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action.__raw = ''function() Snacks.picker.buffers() end'';
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action.__raw = ''function() Snacks.picker.recent() end'';
        options.desc = "Recent Files";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = ''function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true }) end'';
        options.desc = "Find Config";
      }

      # Git
      {
        mode = "n";
        key = "<leader>gg";
        action.__raw = ''function() Snacks.lazygit() end'';
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = ''function() Snacks.git.blame_line() end'';
        options.desc = "Git Blame";
      }

      # Terminal
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle Terminal";
      }
    ];

    # =========================================================
    # Plugins
    # =========================================================
    plugins = {
      # Statusline
      lualine = {
        enable = true;
        settings.options = {
          theme = "tokyonight";
          globalstatus = true;
        };
      };

      # Bufferline
      bufferline.enable = true;

      # Dateibaum
      neo-tree = {
        enable = true;
        filesystem.filteredItems = {
          visible = true;
          hideDotfiles = false;
          hideGitignored = false;
        };
      };

      # Snacks (Picker, Lazygit, Notifier, etc.)
      snacks = {
        enable = true;
        settings = {
          picker = {
            enabled = true;
            sources.files.hidden = true;
            sources.grep.hidden = true;
          };
          lazygit.enabled = true;
          git.enabled = true;
          bigfile.enabled = true;
          notifier.enabled = true;
          statuscolumn.enabled = true;
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-d>" = "cmp.mapping.scroll_docs(4)";
            "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
            {name = "path";}
          ];
        };
      };

      luasnip.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true; # Nix
          lua-ls.enable = true; # Lua
          astro.enable = true; # Astro
          texlab.enable = true; # LaTeX
        };
        keymaps = {
          lspBuf = {
            "gd" = {
              action = "definition";
              desc = "Go to Definition";
            };
            "gD" = {
              action = "declaration";
              desc = "Go to Declaration";
            };
            "gr" = {
              action = "references";
              desc = "References";
            };
            "gi" = {
              action = "implementation";
              desc = "Go to Implementation";
            };
            "K" = {
              action = "hover";
              desc = "Hover";
            };
            "<leader>cr" = {
              action = "rename";
              desc = "Rename";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Action";
            };
          };
        };
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            nix = ["nixfmt"];
            lua = ["stylua"];
            astro = ["prettier"];
            tex = ["latexindent"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            css = ["prettier"];
            html = ["prettier"];
          };
        };
      };

      # Linting
      lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix"];
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
          lua
          astro
          javascript
          typescript
          css
          html
          latex
        ];
      };

      # Git Signs
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-\\>]]";
          float_opts.border = "curved";
        };
      };

      # Autopairs
      nvim-autopairs.enable = true;

      # Kommentare
      comment.enable = true;

      # Which-key
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffer";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Terminal";
          }
          {
            __unkeyed-1 = "<leader>l";
            group = "LSP";
          }
        ];
      };

      # Indent guides
      indent-blankline.enable = true;

      # Mini
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = {};
          ai = {};
        };
      };

      web-devicons.enable = true;
    };

    # =========================================================
    # Autocommands
    # =========================================================
    autoCmd = [
      {
        event = ["BufWritePost" "BufReadPost" "InsertLeave"];
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      }
      {
        event = "TextYankPost";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    # =========================================================
    # Pakete
    # =========================================================
    extraPackages = with pkgs; [
      # LSP
      nil
      lua-language-server
      nodePackages."@astrojs/language-server"
      texlab

      # Formatter
      nixfmt-rfc-style
      stylua
      nodePackages.prettier
      texlivePackages.latexindent

      # Linter
      statix
      deadnix

      # Sonstiges
      lazygit
      ripgrep
      fd
    ];
  };
}
