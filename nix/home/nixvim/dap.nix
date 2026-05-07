{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      dap.enable = true;
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
    };

    extraConfigLua = ''
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      ---------------------------------------------------
      -- TypeScript / Node
      ---------------------------------------------------

      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = {
          "${pkgs.nodePackages.node-debug2-adapter}/bin/node-debug2-adapter"
        },
      }

      dap.configurations.typescript = {
        {
          name = "Launch current file",
          type = "node2",
          request = "launch",
          program = "$''${file}",
          cwd = "$''${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          name = "Attach to process",
          type = "node2",
          request = "attach",
          processId = require('dap.utils').pick_process,
        },
      }

      dap.configurations.javascript = dap.configurations.typescript

      ---------------------------------------------------
      -- Java
      ---------------------------------------------------

      dap.configurations.java = {
        {
          type = "java",
          request = "launch",
          name = "Launch Java Main",
          mainClass = function()
            return vim.fn.input("Main class > ")
          end,
          projectName = function()
            return vim.fn.input("Project name > ")
          end,
        },
        {
          type = "java",
          request = "attach",
          name = "Attach to remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      local ok, jdtls = pcall(require, "jdtls")
      if ok then
        jdtls.setup_dap({ hotcodereplace = "auto" })
        jdtls.setup.add_commands()
      end

      require('dap.ext.vscode').load_launchjs()

      ---------------------------------------------------
      -- Keymaps
      ---------------------------------------------------

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>di", dap.step_into)
      vim.keymap.set("n", "<leader>do", dap.step_over)
      vim.keymap.set("n", "<leader>dO", dap.step_out)
      vim.keymap.set("n", "<leader>du", dapui.toggle)
    '';
  };

  home.packages = with pkgs; [
    nodejs
    nodePackages.node-debug2-adapter
    jdk17
    jdt-language-server
  ];
}
