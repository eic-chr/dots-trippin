-- vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ffffff", bold = true })
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- deine Flash-Optionen hier
  },
  config = function(_, opts)
    require("flash").setup(opts)

    -- Highlight-Gruppen setzen
    local set_hl = vim.api.nvim_set_hl
    set_hl(0, "FlashLabel",    { fg = "#ffffff", bold = true })
  end,
}


