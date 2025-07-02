return {
  "zk-org/zk-nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },

  config = function()
    require("zk").setup({
      picker = "telescope", -- Alternativ: "select"
    })

    local zk = require("zk")
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    local zk_root = require("zk.util").notebook_root(vim.fn.expand("%:p"))

    -- if zk_root ~= nil then
    -- Normal mode keybindings
    map("n", "<leader>zn", function()
      zk.new({ title = vim.fn.input("Titel: ") })
    end, { desc = "Zettel: Neue Notiz" })

    map("n", "<leader>zf", function()
      zk.edit({ search = "" })
    end, { desc = "Zettel: Suche (Volltext)" })

    map("n", "<leader>zt", function()
      zk.edit({ tag = vim.fn.input("Tag: ") })
    end, { desc = "Zettel: Suche nach Tag" })

    map("n", "<leader>zb", function()
      zk.index()
    end, { desc = "Zettel: Backlinks anzeigen" })
  end,
  -- end,
}
