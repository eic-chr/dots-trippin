{ ... }:

{
  programs.nixvim.extraConfigLua = ''

    local zk_dir = vim.fn.expand("$HOME/projects/ceickhoff/zettelkasten/personal")

    require("zk").setup({
      picker = "snacks_picker",
      lsp = {
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
        },
        auto_attach = { enabled = true },
      },
    })

    vim.keymap.set("n", "<leader>zo", "<cmd>ZkNotes<CR>", { desc = "Open notes" })
    vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<CR>", { desc = "Browse tags" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        if not pcall(require, "zk.util") then return end
        if require("zk.util").notebook_root(vim.fn.expand("%:p")) == nil then return end

        vim.keymap.set("n", "<CR>", vim.lsp.buf.definition, { buffer = true, desc = "Follow link" })
        vim.keymap.set("n", "<leader>zb", "<cmd>ZkBacklinks<CR>", { buffer = true })
        vim.keymap.set("n", "<leader>zl", "<cmd>ZkLinks<CR>", { buffer = true })
      end,
    })

  '';
}
