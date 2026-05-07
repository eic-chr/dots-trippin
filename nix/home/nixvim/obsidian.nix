{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;

      settings = {
        workspaces = [{
          name = "notes";
          path = "~/notes";
        }];
        # completion.nvim_cmp = true;

        daily_notes = {
          folder = "daily";
          date_format = "%Y-%m-%d";
          alias_format = "%B %-d, %Y";
          template = "daily.md";
        };

        templates = {
          folder = "templates";
          date_format = "%Y-%m-%d";
          time_format = "%H:%M";
        };
      };
    };

    extraConfigLua = ''
      local map = vim.keymap.set
      map('n', '<leader>on', '<cmd>ObsidianNew<cr>')
      map('n', '<leader>od', '<cmd>ObsidianToday<cr>')
      map('n', '<leader>oy', '<cmd>ObsidianYesterday<cr>')
      map('n', '<leader>of', '<cmd>ObsidianQuickSwitch<cr>')
      map('n', '<leader>os', '<cmd>ObsidianSearch<cr>')
      map('n', '<leader>ol', '<cmd>ObsidianLinks<cr>')
      map('n', '<leader>ob', '<cmd>ObsidianBacklinks<cr>')
      map('n', '<leader>ot', '<cmd>ObsidianTemplate<cr>')
    '';
  };

  # Templates managed via Home Manager -> ~/notes/templates/
  home.file."notes/templates/daily.md".text = ''
    # {{date}}

    ## Tasks
    - [ ] 

    ## Notes


    ## Journal

  '';

  home.file."notes/templates/note.md".text = ''
    # {{title}}

    ## Context


    ## Content


    ## Links

  '';
}
