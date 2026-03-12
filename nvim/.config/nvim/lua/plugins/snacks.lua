return {
  {
    "folke/snacks.nvim",
    opts = {
      zen = {
        twilight = { enabled = true },
        toggles = {
          dim = false,
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
        on_open = function()
          vim.g.zen_prev_diagnostic_config = vim.diagnostic.config()
          vim.diagnostic.config({ virtual_text = false, float = { enabled = false } })
          require("twilight").enable()
          vim.fn["pencil#init"]({ wrap = "soft" }) -- Pencil beim Öffnen aktivieren
        end,
        on_close = function()
          vim.diagnostic.config(vim.g.zen_prev_diagnostic_config)
          require("twilight").disable()
          vim.cmd("PencilOff") -- Pencil beim Schließen deaktivieren
        end,
      },
      styles = {
        zen = {
          enter = true,
          fixbuf = false,
          minimal = false,
          width = 0.8,
          height = 0,
          backdrop = { transparent = true, blend = 20 },
          keys = { q = false },
          zindex = 40,
          wo = {
            winhighlight = "NormalFloat:Normal",
          },
          w = {
            snacks_main = true,
          },
        },
      },
    },
  },
}
