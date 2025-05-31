-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local ok, dap = pcall(require, "dap")
if ok then
  vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
  vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
  vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
  vim.keymap.set("n", "<Leader>ds", dap.terminate, { desc = "DAP: Stop" })
end
