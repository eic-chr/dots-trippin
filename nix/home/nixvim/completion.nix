{ ... }:

{
  programs.nixvim.plugins = {
    blink-cmp.enable = true;
    luasnip.enable = true;
    friendly-snippets.enable = true;
    lsp-signature.enable = true;
  };
}
