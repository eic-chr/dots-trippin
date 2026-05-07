{...}: {
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      astro.enable = true;
      clangd.enable = true;
      cssls.enable = true;
      html.enable = true;
      hyprls.enable = true;
      lua_ls.enable = true;
      marksman.enable = true;
      nil_ls.enable = true;
      pyright.enable = true;
      ts_ls.enable = true;
      terraformls.enable = true;
    };

    keymaps = {
      lspBuf."<leader>ca" = "code_action";
      diagnostic = {
        "<leader>dl" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };
  };
}
