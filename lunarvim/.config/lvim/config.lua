lvim.leader = ','
lvim.colorscheme = "tokyonight-night"
lvim.format_on_save = true
vim.opt.relativenumber = true -- relative line numbers
vim.diagnostic.config({ virtual_text = true })
-- Language Specific
-- =========================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "gopls",
  "golangci_lint_ls",
  "jdtls",
  "texlab",
  "tsserver",
  "yamlls",
})
print("config loaded")

-- Define a key mapping to call the function
lvim.builtin.treesitter.highlight.enable = true

-- Auto install treesitter parsers.
lvim.builtin.treesitter.ensure_installed = { "latex", "javascript", "typescript", "java", "go", "gomod" }
require "user.plugins"
require "user.cmp"
require "user.java"
require "user.jsts"
require "user.keymappings"
require "user.neogit"
require "user.snippets"
require "user.whichkey"
require "user.zk"
require("user.treesitter")
require("user.zen-mode")
require "user.codeium"
require "user.markdown"
-- require "user.surround"
-- vim.cmd(":RltvNmbr")
print("config loaded")

-- lvim.builtin.lualine = {
--   options = {
--     -- theme = 'gruvbox',
--     section_separators = {'', ''},
--     component_separators = {'', ''},
--   },
--   sections = {
--     lualine_a = {'mode'},
--     lualine_b = {'branch'},
--     lualine_c = {'filename'},
--     lualine_x = {'filetype'},
--     lualine_y = {'progress'},
--     lualine_z = {'location'}
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {'filename'},
--     lualine_x = {'location'},
--     lualine_y = {},
--     lualine_z = {}
--   },
-- }


vim.g.GPGExecutable = "PINENTRY_USER_DATA='' gpg --trust-model always"

-- vim.g.encrypt({
--   recipients = "Christian Eickhoff",
--   armor = true,
--   sign = false,
--   input = "Hello, world!"
-- })

local fun = require("telekasten")
-- print(fun)
-- Define the path to the log file
local logFilePath = vim.fn.stdpath('data') .. '/lunarvim.log'

-- Open the log file in append mode
local logFile = io.open(logFilePath, 'a')

-- Define a function to write a log entry
local function writeToLog(message)
  -- Get the current date and time
  local dateTime = os.date('%Y-%m-%d %H:%M:%S')

  -- Construct the log entry
  local logEntry = string.format('[%s] %s\n', dateTime, message)

  -- Write the log entry to the file
  logFile:write(logEntry)
end

-- Example usage: Write a log entry
writeToLog('This is a log entry from LunarVim')
writeToLog(vim.g)

-- Close the log file
logFile:close()

-- Define a function to encrypt and save the buffer
local function encryptAndSave()
  vim.cmd(':write !gpg -e -a -r christian@ewolutions.de m -o %:p.gpg -')
end

-- Create a command to trigger the function
-- lvim.builtin.which_key.mappings['<leader>es'] = { '<cmd>lua encryptAndSave()<CR>', 'Encrypt and Save' }

-- Define a Lua function to call a system command
function EXEC_SYS_CMD(command)
  -- Call the system command and capture its output
  print("gpg -e -a -r christian@ewolutions.de m -o %:p.gpg -'")
  vim.cmd('!gpg --default-recipient-self -ae 2>/dev/null')
  -- vim.cmd(':write !gpg -e -a -r christian@ewolutions.de m -o %:p.gpg -')
  -- local output = vim.fn.system(command)

  -- -- Print the output (optional)
  -- if output ~= nil and output ~= "" then
  --     print(output)
  -- end
end

-- Example: Call a system command to list files in the current directory
vim.api.nvim_set_keymap('n', 'Ms', ':lua EXEC_SYS_CMD("ls -l")<CR>', { noremap = true, silent = true })
-- lvim.builtin.which_key.setup.options.ignore_case = true
-- vim.opt.textwidth = 120 -- Adjust the value as needed
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2'


vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Standard Diff Highlights
    vim.cmd [[
      highlight DiffAdd    guibg=#144212 guifg=NONE
      highlight DiffChange guibg=#3b3f26 guifg=NONE
      highlight DiffDelete guibg=#4a1a1a guifg=NONE
      highlight DiffText   guibg=#1f4a7a guifg=NONE
    ]]
    -- Neogit Diff Highlights
    vim.cmd [[
      highlight NeogitDiffAdd      guifg=#88cc88 guibg=NONE
      highlight NeogitDiffDelete   guifg=#ff8888 guibg=NONE
      highlight NeogitDiffContext  guifg=#aaaaaa guibg=NONE
      highlight NeogitHunkHeader   guifg=#ffffff guibg=#444444 gui=bold
      highlight NeogitCursorLine   guibg=#333333
    ]]
    -- Diffview spezifisch
    vim.cmd [[
      highlight DiffviewDiffAdd         guibg=#1e3f2f guifg=NONE
      highlight DiffviewDiffAddAsDelete guibg=#442222 guifg=NONE
      highlight DiffviewDiffDelete      guibg=#4a1a1a guifg=NONE
      highlight DiffviewDiffChange      guibg=#3b3f26 guifg=NONE
      highlight DiffviewDiffText        guibg=#1f4a7a guifg=NONE
    ]]
  end,
})
