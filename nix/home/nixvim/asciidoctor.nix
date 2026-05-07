{pkgs,...}:
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;
      autoLoad = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      live-preview-nvim
    ];

    extraConfigLua = ''
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = "*.adoc",
      command = "set filetype=asciidoc"
    })
      require("markview").setup({ preview = { enable = true },asciidoc = { enable = true } })
    require("live-preview").setup({
      -- Live-Updates beim Tippen
      templates = {
        AsciiDoc = {
          command = "live-preview --browser --open --file ",
        },
      },
    })

    vim.keymap.set("n", "<leader>ap", ":LivePreviewToggle<CR>", { desc = "AsciiDoc Live Preview" })
    '';
  };
}
