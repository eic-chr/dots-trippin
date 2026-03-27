-- lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = { adapter = "openai" },
      inline = { adapter = "openai" },
    },
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          schema = {
            model = { default = "claude-sonnet-4-5" },
          },
        })
      end,
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          schema = {
            model = { default = "gpt-5.2" },
          },
        })
      end,
    },
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Chat Toggle" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Assist" },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
  },
}
