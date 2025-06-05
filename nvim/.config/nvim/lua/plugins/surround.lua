-- In ~/.config/nvim/lua/plugins/surround.lua
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({})
  end,
}
