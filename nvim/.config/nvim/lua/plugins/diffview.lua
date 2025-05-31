return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff (project)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
    },
  },
}
