-- Setup lsp.
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })

local capabilities = require("lvim.lsp").common_capabilities()

-- require("typescript").setup {
--   -- disable_commands = false, -- prevent the plugin from creating Vim commands
--   debug = false, -- enable debug logging for commands
--   go_to_source_definition = {
--     fallback = true, -- fall back to standard LSP definition on failure
--   },
--   server = { -- pass options to lspconfig's setup method
--     on_attach = require("lvim.lsp").common_on_attach,
--     on_init = require("lvim.lsp").common_on_init,
--     capabilities = capabilities,
--     settings = {
--       typescript = {
--         inlayHints = {
--           includeInlayEnumMemberValueHints = true,
--           includeInlayFunctionLikeReturnTypeHints = true,
--           includeInlayFunctionParameterTypeHints = false,
--           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
--           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--           includeInlayPropertyDeclarationTypeHints = true,
--           includeInlayVariableTypeHints = true,
--         },
--       },
--     },
--   },
-- }

-- -- Set a formatter.
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "prettier", filetypes = { "javascript", "typescript", "css" } },
-- }

local pack_path = vim.fn.glob(vim.fn.stdpath "data" .. "/")
require("dap-vscode-js").setup {
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug",
  
  debugger_path = os.getenv('HOME') .. '/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug',
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
}

-- require("dap-vscode-js").setup({
--   -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--   -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--   -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
--   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
--   log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })

for _, language in ipairs { "typescript", "javascript" } do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end

-- Set a linter.
-- local linters = require("lvim.lsp.null-ls.linters")
-- linters.setup({
--   { command = "eslint", filetypes = { "javascript", "typescript" } },
-- })
