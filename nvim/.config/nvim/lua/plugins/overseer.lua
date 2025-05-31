return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
  },
  opts = {
    -- Optional: Overseer Konfiguration anpassen
    templates = { "builtin" },
  },
  config = function(_, opts)
    require("overseer").setup(opts)
  end,
}
