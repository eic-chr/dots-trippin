local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
lvim.builtin.terminal.active = true
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.open_mapping = "<c-t>"

-- lvim.builtin.terminal.execs = {
--     { nil, "<C-1>", "Horizontal Terminal", "horizontal", 0.3 },
--     { nil, "<C-3>", "Vertical Terminal", "vertical", 0.4 },
--     -- { nil, "<C-3>", "Float Terminal", "float", nil },
--   }


-- {
--   { vim.o.shell, "<c-1>", "Horizontal Terminal", "horizontal", 0.3 },
--   { vim.o.shell, "<c-2>", "Vertical Terminal", "vertical", 0.4 },
--   --       { vim.o.shell, "<C-3>", "Float Terminal", "float", nil },
-- }

keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
keymap("n", "<C-z>", "<cmd>ZenMode<cr>", opts)

