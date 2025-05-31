return {
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  -- DAP Core
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio", -- wird für nvim-dap-ui benötigt
    },
    config = function()
      local dap = require("dap")
      -- local js_debug_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"
      local js_debug_path = "/Users/christianeickhoff/Downloads/js-debug/src"

      dap.adapters["node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/dapDebugServer.js", "${port}" },
        },
      }
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/dapDebugServer.js", "${port}" },
        },
      }

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          cwd = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**" },
        },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach to process (9229)",
        --   port = 9229,
        --   cwd = vim.fn.getcwd(),
        --   sourceMaps = true,
        --   protocol = "inspector",
        --   skipFiles = { "<node_internals>/**" },
        -- },
        -- {
        --   type = "pwa-node",
        --   request = "launch",
        --   name = "Launch file",
        --   program = "${file}",
        --   cwd = vim.fn.getcwd(),
        --   sourceMaps = true,
        --   console = "integratedTerminal",
        -- },
        {
          type = "pwa-node",
          request = "attach",
          sourceMaps = true,
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        -- {
        --   name = "Astro: npm run dev mit Debugger",
        --   type = "pwa-node",
        --   request = "launch",
        --   runtimeExecutable = "npm",
        --   runtimeArgs = { "run", "dev" },
        --   args = {},
        --   cwd = "${workspaceFolder}",
        --   -- cwd = vim.fn.getcwd(),
        --   protocol = "inspector",
        --   port = 9229,
        --   sourceMaps = true,
        --   skipFiles = { "<node_internals>/**" },
        --   console = "integratedTerminal",
        -- },
        {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = "pwa-node",
          -- attach to an already running node process with --inspect flag
          -- default port: 9222
          request = "attach",
          processId = function()
            local pick_process = require("dap.utils").pick_process
            return pick_process({
              filter = function(proc)
                return proc.name:match("node") -- nur node-Prozesse
              end,
              format = function(proc)
                -- Custom-Format: PID + nur der Befehl, max 80 Zeichen
                return string.format("%6d  %s", proc.pid, vim.fn.strcharpart(proc.name, 0, 80))
              end,
            })
          end,
          --   return coroutine.create(function(coro)
          --     local opts = {}
          --     local processes = {}
          --
          --     -- Hole alle node-Prozesse mit vollständigem Kommando
          --     local handle = io.popen("ps -eo pid=,args=")
          --     if handle then
          --       for line in handle:lines() do
          --         line = line:gsub("^%s+", "") -- führende Leerzeichen entfernen
          --         local pid, args = line:match("^(%d+)%s+(.+)$") -- if pid and args then
          --         if pid and args then
          --           table.insert(processes, {
          --             display = string.format("%s (PID: %s)", args, pid),
          --             pid = pid,
          --           })
          --         end
          --       end
          --       handle:close()
          --     end
          --
          --     if #processes == 0 then
          --       vim.notify("Keine Node-Prozesse gefunden", vim.log.levels.WARN)
          --       return
          --     end
          --
          --     require("telescope.pickers")
          --       .new(opts, {
          --         prompt_title = "Wähle Node-Prozess",
          --         finder = require("telescope.finders").new_table({
          --           results = processes,
          --           entry_maker = function(entry)
          --             return {
          --               value = entry,
          --               display = entry.display,
          --               ordinal = entry.display,
          --             }
          --           end,
          --         }),
          --         sorter = require("telescope.config").values.generic_sorter(opts),
          --         attach_mappings = function(buffer_number)
          --           require("telescope.actions").select_default:replace(function()
          --             require("telescope.actions").close(buffer_number)
          --             local selection = require("telescope.actions.state").get_selected_entry()
          --             if selection then
          --               coroutine.resume(coro, tonumber(selection.value.pid))
          --             end
          --           end)
          --           return true
          --         end,
          --       })
          --       :find()
          --   end)
          -- end, -- allows us to pick the process using a picker
          -- processId = require 'dap.utils'.pick_process({ filter = "node" }),
          -- name of the debug action
          name = "Attach debugger to existing `node --inspect` process",
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          -- path to src in vite based projects (and most other projects as well)
          cwd = "${workspaceFolder}/src",
          -- we don't want to debug code inside node_modules, so skip it!
          skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
    end,
  },
  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      -- {
      --   "<leader>db",
      --   function()
      --     require("dap").toggle_breakpoint()
      --   end,
      --   desc = "Toggle Breakpoint",
      -- },
    },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      -- Auto Open/Close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
