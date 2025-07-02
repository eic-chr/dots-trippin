-- Add the key mappings only for Markdown files in a zk notebook
if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  local zk = require("zk")

  local opts = { noremap = true, silent = false, buffer = true }

  local function map(mode, lhs, rhs, more_opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, more_opts or {}))
  end

  -- Hilfsfunktion: Liste aller Templates im aktuellen Notebook (.zk/templates)
  local function list_templates()
    local zk_util = require("zk.util")
    local notebook_root = zk_util.notebook_root(vim.fn.expand("%:p"))
    -- local template_dir = vim.fn.stdpath("config") .. "/../zk/templates"
    local template_dir = vim.fn.expand("~/.config/zk/templates")
    -- Fallback auf globalen Template-Pfad
    print(template_dir .. "is the key")
    local files = vim.fn.isdirectory(template_dir) == 1 and vim.fn.readdir(template_dir) or {}

    return vim.tbl_filter(function(f)
      return f:match("%.md$")
    end, files)
  end

  -- <leader>zn: Neue Notiz mit interaktivem Template-Picker und Titelabfrage
  map("n", "<leader>zn", function()
    local templates = list_templates()
    local template_dir = vim.fn.stdpath("config") .. "/../zk/templates"
    if #templates == 0 then
      print(
        "Keine Templates gefunden in .zk/templates oder in " .. template_dir .. "dir " .. vim.fn.readdir(template_dir)
      )
      return
    end

    vim.ui.select(templates, { prompt = "Template wählen:" }, function(choice)
      if not choice then
        print("Abgebrochen")
        return
      end

      local title = vim.fn.input("Titel: ")
      if title == "" then
        print("Kein Titel angegeben, Abbruch")
        return
      end

      zk.new({
        title = title,
        dir = vim.fn.expand("%:p:h"),
        template = choice,
      })
    end)
  end)

  -- Andere nützliche Mappings

  -- Link unter Cursor folgen
  map("n", "<CR>", vim.lsp.buf.definition)

  -- Neue Notiz aus Auswahl als Titel
  map("v", "<leader>znt", function()
    zk.new_from_title_selection({
      dir = vim.fn.expand("%:p:h"),
    })
  end)

  -- Neue Notiz aus Auswahl als Inhalt + Titel abfragen
  map("v", "<leader>znc", function()
    zk.new_from_content_selection({
      title = vim.fn.input("Title: "),
      dir = vim.fn.expand("%:p:h"),
    })
  end)

  -- Backlinks öffnen
  map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>")

  -- Vorwärtslinks öffnen
  map("n", "<leader>zl", "<Cmd>ZkLinks<CR>")

  -- Hover anzeigen
  map("n", "K", vim.lsp.buf.hover)

  -- Code-Actions im visuellen Modus
  map("v", "<leader>za", function()
    vim.lsp.buf.range_code_action()
  end)

  -- Visuelle Auswahl in Link umwandeln
  map("v", "<leader>zL", function()
    local content = vim.fn.getreg("v")
    zk.link({ content = content })
  end, { desc = "Zettel: Link aus Auswahl" })

  -- Insert-Modus: [[ → Link-Vervollständigung starten
  map("i", "[[", function()
    return zk.complete_link()
  end, { expr = true, desc = "Zettel: Link-Vervollständigung" })
end
