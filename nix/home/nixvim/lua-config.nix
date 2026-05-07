{ ... }:

{
  programs.nixvim.extraConfigLua = ''

    -- Diagnostics UI
    vim.diagnostic.config({
      virtual_text = { prefix = "●", spacing = 2 },
      update_in_insert = true,
      severity_sort = true,
      underline = true,
      signs = true,
    })

    -- LSP Attach mappings
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buf = args.buf
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      end,
    })

  '';
}
