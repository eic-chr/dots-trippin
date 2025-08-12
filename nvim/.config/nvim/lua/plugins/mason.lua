return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "tsserver",
        "nil_ls",
        "pyright",
        "tailwindcss",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettier",
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "js-debug-adapter",
        "debugpy",
        "eslint_d",
      },
    })
  end,
}
