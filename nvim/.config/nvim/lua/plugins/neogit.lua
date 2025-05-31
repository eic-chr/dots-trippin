return {
  "TimUntersberger/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = {
    {
      "<leader>gg",
      function()
        require("neogit").open()
      end,
      desc = "Neogit",
    },
  },
}
