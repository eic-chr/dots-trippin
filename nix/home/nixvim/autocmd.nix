{...}: {
  programs.nixvim.autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      callback = {
        __raw = ''
          function(ev)
            vim.keymap.set({ "n", "i" }, "<leader>cb", function()
              local line = vim.api.nvim_get_current_line()
              if line:match("^%s*-%s*%[[ xX]?%]") then
                return
              end

              local new_line = "- [ ] " .. line
              local row = vim.api.nvim_win_get_cursor(0)[1]

              vim.api.nvim_set_current_line(new_line)
              vim.api.nvim_win_set_cursor(0, { row, #new_line })
            end, { buffer = ev.buf, desc = "Checkbox einfügen" })
          end
          '';
      };
    }
    {
      event = "TextYankPost";
      desc = "Highlight on yank";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
          end
          '';
      };
    }
  ];
}
