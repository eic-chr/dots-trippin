{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-pencil
      twilight-nvim
    ];

    extraConfigLua = ''
      -- Twilight
      require("twilight").setup({
          dimming = {
          alpha = 0.25,
          inactive = false,
          },
          context = 20,
          expand = {
          "section",
          "paragraph",
          "document",
          "block",
          "list",
          "function",
          "method",
          "table",
          "if_statement",
          },
          })
      vim.g["pencil#wrapModeDefault"] = "soft"
        vim.g["pencil#textwidth"] = 100
        vim.g["pencil#joinspaces"] = 0

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown", "asciidoc", "text" },
            callback = function()
            vim.fn["pencil#init"]()
            end,
            })
    '';
  };
}
