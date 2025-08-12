-- ~/.config/nvim/lua/plugins/asciidoc.lua
return {
  -- Hauptplugin für AsciiDoc Support
  {
    "habamax/vim-asciidoctor",
    ft = "asciidoc",
    config = function()
      -- Folding aktivieren
      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_fold_options = 1

      -- Syntax-Highlighting verbessern
      vim.g.asciidoctor_syntax_conceal = 1

      -- PDF-Generierung mit asciidoctor-pdf
      vim.g.asciidoctor_pdf_themes_path = vim.fn.expand("~/.config/asciidoc/themes")

      -- Keymaps für AsciiDoc
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Auto-Commands für AsciiDoc-Dateien
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "asciidoc",
        callback = function()
          -- Textbreite für bessere Lesbarkeit
          vim.opt_local.textwidth = 80
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true

          -- Concealment für saubere Darstellung
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"

          -- Spell checking
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "de,en"

          -- Keymaps
          map("n", "<leader>ap", ":AsciidoctorOpenRAW<CR>", { desc = "Preview AsciiDoc" })
          map("n", "<leader>ah", ":AsciidoctorOpenHTML<CR>", { desc = "Open HTML" })
          map("n", "<leader>ax", ":AsciidoctorOpenPDF<CR>", { desc = "Open PDF" })
          map("n", "<leader>ac", ":AsciidoctorTOC<CR>", { desc = "Table of Contents" })

          -- Schnelle Formatierung
          map("n", "<leader>ab", "i**<Esc>ea**<Esc>", { desc = "Bold text" })
          map("n", "<leader>ai", "i__<Esc>ea__<Esc>", { desc = "Italic text" })
          map("n", "<leader>am", "i``<Esc>ea``<Esc>", { desc = "Monospace text" })

          -- Visual mode formatting
          map("v", "<leader>ab", 'c**<C-r>"**<Esc>', { desc = "Bold selection" })
          map("v", "<leader>ai", 'c__<C-r>"__<Esc>', { desc = "Italic selection" })
          map("v", "<leader>am", 'c``<C-r>"``<Esc>', { desc = "Monospace selection" })
        end,
      })
    end,
  },

  -- Tabellen-Support
  {
    "dhruvasagar/vim-table-mode",
    ft = "asciidoc",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_header_fillchar = "="

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "asciidoc",
        callback = function()
          vim.keymap.set("n", "<leader>at", ":TableModeToggle<CR>", { buffer = true, desc = "Toggle Table Mode" })
        end,
      })
    end,
  },

  -- Treesitter Support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "asciidoc" })
      end
    end,
  },

  -- Bessere Textbearbeitung
  {
    "preservim/vim-pencil",
    ft = "asciidoc",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "asciidoc",
        callback = function()
          vim.cmd("call pencil#init({'wrap': 'soft'})")
        end,
      })
    end,
  },

  -- Snippets für AsciiDoc
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("asciidoc", {
        -- Grundlegende Snippets
        s("title", {
          t("= "),
          i(1, "Document Title"),
          t({ "", ":author: " }),
          i(2, "Author Name"),
          t({ "", ":email: " }),
          i(3, "email@example.com"),
          t({ "", ":date: " }),
          i(4, "2024-01-01"),
          t({ "", ":toc:", "", "" }),
          i(0),
        }),

        s("ch1", { t("== "), i(1, "Chapter Title"), t({ "", "" }), i(0) }),
        s("ch2", { t("=== "), i(1, "Section Title"), t({ "", "" }), i(0) }),
        s("ch3", { t("==== "), i(1, "Subsection Title"), t({ "", "" }), i(0) }),

        s("code", {
          t({ "[source," }),
          i(1, "language"),
          t({ "]", "----" }),
          t({ "", "" }),
          i(2, "code here"),
          t({ "", "----", "" }),
          i(0),
        }),

        s("note", {
          t("NOTE: "),
          i(1, "Note text"),
          t({ "", "" }),
          i(0),
        }),

        s("tip", {
          t("TIP: "),
          i(1, "Tip text"),
          t({ "", "" }),
          i(0),
        }),

        s("warn", {
          t("WARNING: "),
          i(1, "Warning text"),
          t({ "", "" }),
          i(0),
        }),

        s("img", {
          t("image::"),
          i(1, "path/to/image.png"),
          t("["),
          i(2, "alt text"),
          t(", width="),
          i(3, "400"),
          t("]"),
          t({ "", "" }),
          i(0),
        }),

        s("link", {
          t("link:"),
          i(1, "https://example.com"),
          t("["),
          i(2, "Link Text"),
          t("]"),
          i(0),
        }),

        s("table", {
          t({ "|===", "| " }),
          i(1, "Header 1"),
          t(" | "),
          i(2, "Header 2"),
          t({ "", "", "| " }),
          i(3, "Cell 1"),
          t(" | "),
          i(4, "Cell 2"),
          t({ "", "|===", "" }),
          i(0),
        }),
      })
    end,
  },
}
