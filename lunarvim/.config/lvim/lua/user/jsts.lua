-- Setup lsp.
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local capabilities = require("lvim.lsp").common_capabilities()

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

require('lspconfig').tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  }
}
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

-- local pack_path = vim.fn.glob(vim.fn.stdpath "data" .. "/")
require("dap-vscode-js").setup {
  node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug",

  debugger_path = os.getenv('HOME') .. '/.local/share/lvim/site/pack/lazy/opt/vscode-js-debug',
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
for _, language in ipairs { "astro", "typescript", "javascript" } do
  require("dap").configurations[language] = {
    {
      -- use nvim-dap-vscode-js's pwa-node debug adapter
      type = "pwa-node",
      -- attach to an already running node process with --inspect flag
      -- default port: 9222
      request = "attach",
      processId = function()
        return coroutine.create(function(coro)
          local opts = {}
          local processes = {}

          -- Hole alle node-Prozesse mit vollständigem Kommando
          local handle = io.popen("ps -eo pid=,args=")
          if handle then
            for line in handle:lines() do
              line = line:gsub("^%s+", "")                   -- führende Leerzeichen entfernen
              local pid, args = line:match("^(%d+)%s+(.+)$") -- if pid and args then
              if pid and args then
                table.insert(processes, {
                  display = string.format("%s (PID: %s)", args, pid),
                  pid = pid,
                })
              end
            end
            handle:close()
          end

          if #processes == 0 then
            vim.notify("Keine Node-Prozesse gefunden", vim.log.levels.WARN)
            return
          end

          require("telescope.pickers")
              .new(opts, {
                prompt_title = "Wähle Node-Prozess",
                finder = require("telescope.finders").new_table {
                  results = processes,
                  entry_maker = function(entry)
                    return {
                      value = entry,
                      display = entry.display,
                      ordinal = entry.display,
                    }
                  end,
                },
                sorter = require("telescope.config").values.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                  require("telescope.actions").select_default:replace(function()
                    require("telescope.actions").close(buffer_number)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    if selection then
                      coroutine.resume(coro, tonumber(selection.value.pid))
                    end
                  end)
                  return true
                end,
              })
              :find()
        end)
      end, -- allows us to pick the process using a picker
      -- processId = require 'dap.utils'.pick_process({ filter = "node" }),
      -- name of the debug action
      name = "Attach debugger to existing `node --inspect` process",
      -- for compiled languages like TypeScript or Svelte.js
      sourceMaps = true,
      -- resolve source maps in nested locations while ignoring node_modules
      resolveSourceMapLocations = { "${workspaceFolder}/**",
        "!**/node_modules/**" },
      -- path to src in vite based projects (and most other projects as well)
      cwd = "${workspaceFolder}/src",
      -- we don't want to debug code inside node_modules, so skip it!
      skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
    },
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
      name = "Astro",
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
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
-- Set a linter.
-- local linters = require("lvim.lsp.null-ls.linters")
-- linters.setup({
--   { command = "eslint", filetypes = { "javascript", "typescript" } },
-- })
