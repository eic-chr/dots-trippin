-- ~/.config/nvim/lua/plugins/zk.lua - Finale Konfiguration
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
    -- === NOTEBOOK MANAGEMENT ===
    {
      "<leader>zs",
      function()
        local notebooks = {
          { name = "Personal", path = "~/projects/ceickhoff/zk/personal" },
          { name = "HUK", path = "~/projects/ceickhoff/zk/huk" },
          { name = "EWO", path = "~/projects/ceickhoff/zk/ewo" },
        }

        vim.ui.select(notebooks, {
          prompt = "Notizbuch auswählen:",
          format_item = function(item)
            return item.name
          end,
        }, function(choice)
          if choice then
            vim.cmd("cd " .. vim.fn.expand(choice.path))
            vim.notify("📚 Switched to: " .. choice.name, vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Switch notebook",
    },

    -- === DIRECT NOTEBOOK SWITCHING ===
    {
      "<leader>zsp",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/personal")
        vim.notify("📚 Personal Notes", vim.log.levels.INFO)
      end,
      desc = "→ Personal",
    },

    {
      "<leader>zsh",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/huk")
        vim.notify("💼 HUK Notes", vim.log.levels.INFO)
      end,
      desc = "→ HUK",
    },

    {
      "<leader>zse",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/ewo")
        vim.notify("🚀 EWO Notes", vim.log.levels.INFO)
      end,
      desc = "→ EWO",
    },

    -- === BASIC OPERATIONS (work in current context) ===
    { "<leader>zn", "<Cmd>ZkNew<CR>", desc = "New note" },
    { "<leader>zo", "<Cmd>ZkNotes<CR>", desc = "Open notes" },
    { "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Browse tags" },
    { "<leader>zf", "<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>", desc = "Find notes" },

    -- === CONTEXT-SPECIFIC NOTE CREATION ===
    {
      "<leader>znp",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/personal")
        local title = vim.fn.input("Personal note: ")
        if title ~= "" then
          require("zk").new({ title = title })
        end
      end,
      desc = "New personal note",
    },

    {
      "<leader>znh",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/huk")
        local title = vim.fn.input("HUK note: ")
        if title ~= "" then
          require("zk").new({ title = title })
        end
      end,
      desc = "New HUK note",
    },

    {
      "<leader>zne",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/ewo")
        local title = vim.fn.input("EWO note: ")
        if title ~= "" then
          require("zk").new({ title = title })
        end
      end,
      desc = "New EWO note",
    },

    -- === DAILY NOTES ===
    {
      "<leader>zd",
      function()
        local result = vim.fn.system("zk daily --print-path")
        local path = vim.trim(result)
        if vim.v.shell_error == 0 and path ~= "" then
          vim.cmd("edit " .. path)
        else
          vim.notify("Error creating daily note", vim.log.levels.ERROR)
        end
      end,
      desc = "Daily note (current)",
    },

    {
      "<leader>zdp",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/personal")
        local result = vim.fn.system("zk daily --print-path")
        local path = vim.trim(result)
        if vim.v.shell_error == 0 and path ~= "" then
          vim.cmd("edit " .. path)
        else
          vim.notify("Error creating personal daily note", vim.log.levels.ERROR)
        end
      end,
      desc = "Personal daily",
    },

    {
      "<leader>zdh",
      function()
        vim.cmd("cd ~/projects/ceickhoff/zk/huk")
        local result = vim.fn.system("zk daily --print-path")
        local path = vim.trim(result)
        if vim.v.shell_error == 0 and path ~= "" then
          vim.cmd("edit " .. path)
        else
          vim.notify("Error creating HUK daily note", vim.log.levels.ERROR)
        end
      end,
      desc = "HUK daily",
    },

    -- === WEEKLY NOTES ===
    {
      "<leader>zW",
      function()
        local result = vim.fn.system("zk weekly --print-path")
        local path = vim.trim(result)
        if vim.v.shell_error == 0 and path ~= "" then
          vim.cmd("edit " .. path)
        else
          vim.notify("Error creating weekly note", vim.log.levels.ERROR)
        end
      end,
      desc = "Weekly note (current)",
    },

    -- === STRUCTURED NOTES (ideas, meetings, projects) ===
    {
      "<leader>znc",
      function()
        local title = vim.fn.input("Checklist title: ")
        if title ~= "" then
          require("zk").new({ dir = "checklists", title = title, template = "checklist" })
        end
      end,
      desc = "New checklist",
    },
    {
      "<leader>zni",
      function()
        local title = vim.fn.input("Idea title: ")
        if title ~= "" then
          require("zk").new({ dir = "ideas", title = title, template = "idea.md" })
        end
      end,
      desc = "New idea",
    },

    {
      "<leader>znm",
      function()
        local title = vim.fn.input("Meeting title: ")
        if title ~= "" then
          require("zk").new({ dir = "meetings", title = title, template = "meeting.md" })
        end
      end,
      desc = "New meeting note",
    },

    {
      "<leader>znj",
      function()
        local title = vim.fn.input("Project title: ")
        if title ~= "" then
          require("zk").new({ dir = "projects", title = title, template = "project.md" })
        end
      end,
      desc = "New project note",
    },

    {
      "<leader>znr",
      function()
        local title = vim.fn.input("Research topic: ")
        if title ~= "" then
          require("zk").new({ dir = "research", title = title, template = "research.md" })
        end
      end,
      desc = "New research note",
    },

    -- === BROWSE STRUCTURED NOTES ===
    { "<leader>zoi", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/ideas' } }<CR>", desc = "Browse ideas" },
    { "<leader>zom", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/meetings' } }<CR>", desc = "Browse meetings" },
    { "<leader>zoj", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/projects' } }<CR>", desc = "Browse projects" },
    { "<leader>zor", "<Cmd>ZkNotes { match = { vim.fn.getcwd() .. '/research' } }<CR>", desc = "Browse research" },

    -- === TEMPLATE SELECTION ===
    {
      "<leader>znt",
      function()
        local folders = { ".", "daily", "weekly", "meetings", "projects", "ideas" }
        vim.ui.select(folders, {
          prompt = "Ordner:",
          format_item = function(item)
            return item == "." and "Root" or item
          end,
        }, function(folder)
          if not folder then
            return
          end

          local templates_dir = vim.fn.expand("~/.config/zk/templates")
          local templates = {}

          local handle = vim.loop.fs_scandir(templates_dir)
          if handle then
            while true do
              local name, type = vim.loop.fs_scandir_next(handle)
              if not name then
                break
              end
              if type == "file" and name:match("%.md$") then
                local template_name = (name:gsub("%.md$", ""))
                table.insert(templates, template_name)
              end
            end
          end

          if #templates == 0 then
            vim.notify("Keine Templates gefunden", vim.log.levels.WARN)
            return
          end

          vim.ui.select(templates, {
            prompt = "Template:",
          }, function(template)
            if template then
              local title = vim.fn.input("Note title: ")
              if title ~= "" then
                require("zk").new({
                  dir = folder == "." and nil or folder,
                  template = template .. ".md",
                  title = title,
                })
              end
            end
          end)
        end)
      end,
      desc = "New note with template",
    },

    -- === GLOBAL SEARCH ===
    {
      "<leader>zfa",
      function()
        local search_term = vim.fn.input("Search all notebooks: ")
        if search_term ~= "" then
          require("telescope.builtin").live_grep({
            search_dirs = {
              vim.fn.expand("~/projects/ceickhoff/zk/personal"),
              vim.fn.expand("~/projects/ceickhoff/zk/huk"),
              vim.fn.expand("~/projects/ceickhoff/zk/ewo"),
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
        elseif string.match(current_dir, "huk") then
          notebook = "HUK"
          icon = "💼"
        elseif string.match(current_dir, "ewo") then
          notebook = "EWO"
          icon = "🚀"
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
