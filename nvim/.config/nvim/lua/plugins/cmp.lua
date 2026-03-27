return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "f3fora/cmp-spell", -- Spell-Vorschläge als cmp-Quelle
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Emoji-Quelle hinzufügen (einfach)
      table.insert(opts.sources or {}, { name = "emoji" })

      -- Spell-Quelle mit Optionen in sources einbauen
      table.insert(opts.sources or {}, {
        name = "spell",
        option = {
          keep_all_entries = false,
          preselect_correct_word = true,
          enable_in_context = function()
            return require("cmp.config.context").in_treesitter_capture("spell")
          end,
        },
        priority = 50,
      })

      -- Mapping erweitern (sicher mergen)
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.SPELL }),
      })

      return opts -- Jetzt korrekt geschlossen
    end,
  },
  -- Optional: spellsitter für @spell-Captures
  {
    "lewis6991/spellsitter.nvim",
    enabled = true,
    opts = {},
  },
}
