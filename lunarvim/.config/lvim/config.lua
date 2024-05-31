lvim.leader = ','
lvim.format_on_save = false
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

lvim.builtin.lualine = {
  options = {
    -- theme = 'gruvbox',
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}




vim.g.GPGExecutable = "PINENTRY_USER_DATA='' gpg --trust-model always"


