-- lua/plugins/rot13.lua
return {
  dir = vim.fn.stdpath("config") .. "/lua/custom", -- Pfad zum Ordner, wo rot13.lua liegt
  name = "rot13-tools",
  init = function()
    require("custom.rot13").setup()
  end,
  keys = {
    { "<leader>re", ":ROT13Encode<CR>", desc = "ROT13 Encode", mode = { "n", "v" } },
    { "<leader>rd", ":ROT13Decode<CR>", desc = "ROT13 Decode", mode = "n" },
  },
}
