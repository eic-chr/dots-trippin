{...}: {
  programs.nixvim = {
    plugins.noice = {
      # ── Noice (LazyVim behält es trotz snacks!) ──────────────────────────────
      # noice: Cmdline-UI, Search-UI, LSP-Progress, Message-Routing
      # snacks.notifier: nur Popup-Notifications
      # Beide zusammen = volle LazyVim-UI-Erfahrung
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              any = [
                {find = "%d+L, %d+B";}
                {find = "; after #%d+";}
                {find = "; before #%d+";}
              ];
            };
            view = "mini";
          }
        ];
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };
    };
    keymaps = [
      {
        key = "<leader>snl";
        action = "<cmd>lua require('noice').cmd('last')<cr>";
        options.desc = "Noice Last Message";
      }
      {
        key = "<leader>snh";
        action = "<cmd>lua require('noice').cmd('history')<cr>";
        options.desc = "Noice History";
      }
      {
        key = "<leader>sna";
        action = "<cmd>lua require('noice').cmd('all')<cr>";
        options.desc = "Noice All";
      }
      {
        key = "<leader>snd";
        action = "<cmd>lua require('noice').cmd('dismiss')<cr>";
        options.desc = "Noice Dismiss";
      }
    ];
  };
}
