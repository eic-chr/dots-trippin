-- Additional Plugins

lvim.plugins = {
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup()
    end,
  },
  {
    "samoshkin/vim-mergetool",
    config = function()
      vim.g.mergetool_layout = 'mr' -- (merge in the middle, remote right, local left)
      vim.g.mergetool_prefer_revision = 'local'
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "lvimuser/lsp-inlayhints.nvim" },
  {
    "Groveer/plantuml.nvim",
    config = function()
      require("plantuml").setup({ renderer = 'text' })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  { "ellisonleao/glow.nvim",       config = true, cmd = "Glow" },
  { "mfussenegger/nvim-jdtls",     ft = "java" },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  'godlygeek/tabular',
  'preservim/vim-markdown',
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
  },
  {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup {
        highlight_on_key = true,
      }
    end,
  },
  -- "theNewDynamic/language-hugo-vscode",
  -- {
  --   'Exafunction/codeium.vim',
  --   config = function()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
  --       { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
  --       { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  --   end
  -- },
  -- "Exafunction/codeium.vim",
  {
    "Zeioth/markmap.nvim",
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
      html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
      hide_toolbar = false,              -- (default)
      grace_period = 3600000             -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts) require("markmap").setup(opts) end
  },
  "phelipetls/vim-hugo",
  "jamessan/vim-gnupg",
  "KeitaNakamura/tex-conceal.vim",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "ajatkj/vim-qotd",
  "f-person/git-blame.nvim",
  "folke/todo-comments.nvim",
  "folke/zen-mode.nvim",
  "kdheepak/cmp-latex-symbols",
  "leoluz/nvim-dap-go",
  "lervag/vimtex",
  "mfussenegger/nvim-dap",
  "mxsdev/nvim-dap-vscode-js",
  "neogitorg/neogit",
  "olexsmir/gopher.nvim",
  "opalmay/vim-smoothie",
  "rafamadriz/friendly-snippets",
  "renerocksai/calendar-vim",
  "sindrets/diffview.nvim",
  "nvim-telescope/telescope-symbols.nvim",
  'vim-scripts/RltvNmbr.vim',
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }
}
