-- lua/plugins/live-preview.lua
return {
  "brianhuster/live-preview.nvim",
  opts = {
    port = 5500,
    browser = "default", -- oder z.B. "firefox", "chromium"
  },
  keys = {
    { "<leader>cp", "<cmd>LivePreview start<cr>", desc = "Live Preview starten" },
    { "<leader>cP", "<cmd>LivePreview stop<cr>", desc = "Live Preview stoppen" },
  },
  {
    "tigion/nvim-asciidoc-preview",
    ft = { "asciidoc" },
    build = "cd server && npm install --omit=dev --no-save",
    opts = {
      server = { converter = "js" },
      preview = { position = "current" },
    },
    keys = {
      { "<leader>cp", "<cmd>AsciiDocPreview<cr>", ft = "asciidoc", desc = "AsciiDoc Preview" },
    },
  },
}
