return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      find_command = "rg",
      find_args = {
        "rg",
        "--files", -- nur Dateinamen
        "--hidden", -- auch versteckte Dateien
        "--glob",
        "!.git", -- .git ausschließen
        "--ignore-case", -- Case-insensitive
      },
    },
    window = {
      mappings = {
        ["/"] = "fuzzy_finder", -- Standard-Filtertaste
        ["<C-f>"] = "fuzzy_finder", -- optional: zusätzliches Mapping
      },
    },
  },
}
