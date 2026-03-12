return {
  {
    "preservim/vim-pencil",
    cmd = { "Pencil", "PencilSoft", "PencilHard", "PencilToggle" },
    ft = { "markdown", "asciidoc", "text" },
    config = function()
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#textwidth"] = 100
      vim.g["pencil#joinspaces"] = 0

      -- automatisch aktivieren für diese Filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "asciidoc", "text" },
        callback = function()
          vim.fn["pencil#init"]()
        end,
      })
    end,
  },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,
        inactive = false,
      },
      context = 20,
      expand = {
        "section", -- AsciiDoc Abschnitt
        "paragraph", -- Absatz
        "document", -- ganzes Dokument als Fallback
        "block",
        "list",
        "function",
        "method",
        "table",
        "if_statement",
      },
    },
  },
}
