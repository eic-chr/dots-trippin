return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
    -- nicht format_on_save hier setzen, LazyVim macht das nicht
  },
  config = function(_, opts)
    require("conform").setup(opts)
    -- Autoformat beim Speichern
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function()
        require("conform").format({
          async = false,
          lsp_fallback = true,
          timeout_ms = 1000,
        })
      end,
    })
  end,
}
