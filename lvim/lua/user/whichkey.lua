
lvim.builtin.which_key.mappings["g"] = {
  name = "Git",
  -- g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle(12000)<cr>", "Lazygit" },
  g = { "<cmd>Neogit<cr>", "Neogit" },
  j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
  k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
  l = { "<cmd>GitBlameToggle<cr>", "Blame" },
  p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
  r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
  R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
  s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
  u = {
    "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
    "Undo Stage Hunk",
  },
  n = { ":!git checkout -b ", "Checkout New Branch" },
  o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
  b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
  c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
  f = { "<cmd>Telescope git_bcommits<cr>", "Checkout buffer commit" },
  d = {
    "<cmd>Gitsigns diffthis HEAD<cr>",
    "Diff",
  },
  G = {
    name = "Gist",
    a = { "<cmd>Gist -b -a<cr>", "Create Anon" },
    d = { "<cmd>Gist -d<cr>", "Delete" },
    f = { "<cmd>Gist -f<cr>", "Fork" },
    g = { "<cmd>Gist -b<cr>", "Create" },
    l = { "<cmd>Gist -l<cr>", "List" },
    p = { "<cmd>Gist -b -p<cr>", "Create Private" },
  },
}
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "Terminal",
--   v = { "<cmd>ToggleTerm direction=vertical size=50<CR>", "vertical Terminal" },
--   h = { "<cmd>ToggleTerm size=10 direction=horizontal<CR>", "horizontal Terminal" },
-- }

local searchKeys = lvim.builtin.which_key.mappings["s"]
searchKeys["s"] = { "<cmd>Telescope symbols<cr>", "Symbols" }
lvim.builtin.which_key.mappings["s"] = searchKeys
