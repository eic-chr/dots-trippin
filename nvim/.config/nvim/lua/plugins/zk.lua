-- ~/.config/nvim/lua/plugins/zk.lua - Finale Konfiguration
local zk_dir = "~/projects/ceickhoff/zettelkasten/personal"

local function new_zettel(alias, needs_title, title)
  return function()
    local opts = {
      dir = alias,
      template = alias .. ".md",
    }

    vim.fn.chdir(zk_dir)

    if needs_title then
      if title and title ~= "" then
        opts.title = title
      else
        opts.title = vim.fn.input("Title: ")
      end
    end

    require("zk").new(opts)
  end
end

return {
  "zk-org/zk-nvim",
  name = "zk",
  lazy = false, -- Immer verfügbar für Notizen-Erstellung
  config = function()
    require("zk").setup({
      picker = "telescope",
    })
  end,
  keys = {
    { "<leader>zo", "<Cmd>ZkNotes<CR>", desc = "Open notes" },
    { "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Browse tags" },
    { "<leader>zf", "<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>", desc = "Find notes" },

    -- === CONTEXT-SPECIFIC NOTE CREATION ===
    {
      "<leader>zn",
      function()
        vim.fn.chdir(zk_dir)
        local title = vim.fn.input("Note: ")
        if title ~= "" then
          require("zk").new({ title = title })
        end
      end,
      desc = "New note",
    },

    -- === DAILY NOTES ===
    {
      "<leader>zd",
      function()
        -- Einfacher Date-Picker mit Optionen
        local options = {
          "Today (" .. os.date("%Y-%m-%d") .. ")",
          "Yesterday (" .. os.date("%Y-%m-%d", os.time() - 24 * 60 * 60) .. ")",
          "Tomorrow (" .. os.date("%Y-%m-%d", os.time() + 24 * 60 * 60) .. ")",
          "2 days ago (" .. os.date("%Y-%m-%d", os.time() - 2 * 24 * 60 * 60) .. ")",
          "3 days ago (" .. os.date("%Y-%m-%d", os.time() - 3 * 24 * 60 * 60) .. ")",
          "This Monday (" .. os.date("%Y-%m-%d", os.time() - (os.date("*t").wday - 2) * 24 * 60 * 60) .. ")",
          "Last Monday (" .. os.date("%Y-%m-%d", os.time() - (os.date("*t").wday - 2 + 7) * 24 * 60 * 60) .. ")",
          "Custom date...",
        }

        vim.ui.select(options, {
          prompt = "Select date for daily note:",
        }, function(choice)
          local date = choice and choice:match("%((%d%d%d%d%-%d%d%-%d%d)%)")
          if not date then
            date = vim.fn.input("Enter custom date (YYYY-MM-DD): ")
          end
          vim.notify("on thenew_zettel", vim.log.levels.INFO)
          new_zettel("daily", true, date)()
        end)
      end,
      desc = "Daily",
    },

    -- === WEEKLY NOTES ===
    {
      "<leader>zw",
      new_zettel("weekly", false),
      desc = "Weekly note",
    },

    -- === STRUCTURED NOTES (ideas, meetings, projects) ===
    {
      "<leader>znf",
      new_zettel("fleeting", true),
      desc = "Fleeting note",
    },
    {
      "<leader>znp",
      new_zettel("permanent", true),
      desc = "Permanent note",
    },
    {
      "<leader>znc",
      new_zettel("checklist", true),
      desc = "New checklist",
    },
    {
      "<leader>zni",
      new_zettel("idea", true),
      desc = "New idea",
    },
    {
      "<leader>znm",
      new_zettel("meeting", true),
      desc = "New meeting note",
    },
    {
      "<leader>znr",
      new_zettel("research", true),
      desc = "New research note",
    },

    -- === BROWSE STRUCTURED NOTES ===
    { "<leader>zoi", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/idea' } }<CR>", desc = "Browse ideas" },
    { "<leader>zom", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/meeting' } }<CR>", desc = "Browse meetings" },
    { "<leader>zoj", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/project' } }<CR>", desc = "Browse projects" },
    { "<leader>zor", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/research' } }<CR>", desc = "Browse research" },
    -- === GLOBAL SEARCH ===
    {
      "<leader>zfa",
      function()
        local search_term = vim.fn.input("Search all notebooks: ")
        if search_term ~= "" then
          require("telescope.builtin").live_grep({
            search_dirs = {
              vim.fn.expand("~/projects/ceickhoff/zettelkasten/personal"),
            },
            prompt_title = "🔍 All Notebooks",
            default_text = search_term,
          })
        end
      end,
      desc = "Search all notebooks",
    },

    -- === INFO & STATUS ===
    {
      "<leader>zi",
      function()
        local current_dir = vim.fn.getcwd()
        local notebook = "Unknown"
        local icon = "📁"

        if string.match(current_dir, "personal") then
          notebook = "Personal"
          icon = "🏠"
        end

        vim.notify(icon .. " Current: " .. notebook .. "\n📂 " .. current_dir, vim.log.levels.INFO)
      end,
      desc = "Current notebook info",
    },

    -- === LINKS (Visual mode) ===
    { "<leader>zl", ":'<,'>ZkNewFromTitleSelection<CR>", mode = "v", desc = "Create link from selection" },
  },

  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
}
