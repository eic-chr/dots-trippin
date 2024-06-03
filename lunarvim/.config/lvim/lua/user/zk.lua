local home_root = vim.fn.expand("~/projects/ceickhoff/zettelkasten/vaults/")
local home_ewo = home_root .. '/ewo'
local home_huk = home_root .. '/huk'
local home_personal = home_root .. '/personal'
-- NOTE for Windows users:
-- - don't use Windows
-- - try WSL2 on Windows and pretend you're on Linux
-- - if you **must** use Windows, use "/Users/myname/zettelkasten" instead of "~/zettelkasten"
-- - NEVER use "C:\Users\myname" style paths
-- - Using `vim.fn.expand("~/zettelkasten")` should work now but mileage will vary with anything outside of finding and opening files
require('telekasten').setup({
  vaults = {
    ewo = {
      home         = home_ewo,
      dailies      = home_ewo .. '/journal/daily-notes',
      weeklies     = home_ewo.. '/journal/weekly-notes',
      monthlies     = home_ewo.. '/journal/monthly-notes',
      template_new_daily = home_ewo .. '/templates/daily-notes.md',
      template_new_weekly = home_ewo.. 'journal/weekly-notes.md',
      templates    = home_root .. '/templates',
    },
    huk = {
      home         = home_huk,
      template_new_daily = home_huk .. '/templates/daily-notes.md',
      dailies      = home_huk .. '/journal/daily-notes',
      weeklies     = home_huk .. '/journal/weekly-notes',
      monthlies     = home_huk .. '/journal/monthly-notes',
      template_new_weekly = home_huk.. 'journal/weekly-notes.md',
      templates    = home_root .. '/templates',
      new_note_filename = "title-uuid",
      -- file uuid type ("rand" or input for os.date()")
      -- uuid_type = "%Y%m%d%H%M",
      uuid_type = "rand",
      -- UUID separator
      uuid_sep = "-",
    },
    personal = {
      template_new_daily = home_personal .. '/templates/daily-notes.md',
      home         = home_personal,
      dailies      = home_personal .. '/journal/daily-notes',
      weeklies     = home_personal .. '/journal/weekly-notes',
      monthlies     = home_personal .. '/journal/monthly-notes',
      template_new_weekly = home_personal .. 'journal/weekly-notes.md',
      templates    = home_root .. '/templates',
      extension    = ".md",
    }
  },

  home         = home_root .. '/default',
  take_over_my_home = true,
  auto_set_filetype = true,
  -- dir names for special notes (absolute path or subdir name)
  dailies      = home_root .. '/journal/daily-notes',
  weeklies     = home_root .. '/journal/weekly-notes',
  monthlies     = home_root .. '/journal/monthly-notes',
  templates    = home_root .. '/templates',

  image_subdir = "images",
  extension    = ".md",
  -- Generate note filenames. One of:
  -- "title" (default) - Use title if supplied, uuid otherwise
  -- "uuid" - Use uuid
  -- "uuid-title" - Prefix title by uuid
  -- "title-uuid" - Suffix title with uuid
  new_note_filename = "title-uuid",
  -- file uuid type ("rand" or input for os.date()")
  -- uuid_type = "%Y%m%d%H%M",
  uuid_type = "rand",
  -- UUID separator
  uuid_sep = "-",

  -- following a link to a non-existing note will create it
  follow_creates_nonexisting = false,
  dailies_create_nonexisting = false,
  weeklies_create_nonexisting = false,

  -- skip telescope prompt for goto_today and goto_thisweek
  journal_auto_open = false,

  -- template for new notes (new_note, follow_link)
  -- set to `nil` or do not specify if you do not want a template
  -- template_new_note = home .. '/' .. 'templates/new_note.md',
  template_new_note = nil,

  -- template for newly created daily notes (goto_today)
  -- set to `nil` or do not specify if you do not want a template
  template_new_daily = home_root .. '/templates/daily-notes.md',
  -- template_new_daily = nil,

  -- template for newly created weekly notes (goto_thisweek)
  -- set to `nil` or do not specify if you do not want a template
  -- template_new_weekly= home .. '/' .. 'templates/weekly.md',
  template_new_weekly = nil,

  -- image link style
  -- wiki:     ![[image name]]
  -- markdown: ![](image_subdir/xxxxx.png)
  image_link_style = "markdown",

  -- default sort option: 'filename', 'modified'
  sort = "filename",

  -- integrate with calendar-vim
  plug_into_calendar = true,
  calendar_opts = {
    -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
    weeknm = 4,
    -- use monday as first day of week: 1 .. true, 0 .. false
    calendar_monday = 1,
    -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
    calendar_mark = 'left-fit',
  },

  -- telescope actions behavior
  close_after_yanking = false,
  insert_after_inserting = true,

  -- tag notation: '#tag', ':tag:', 'yaml-bare'
  tag_notation = "#tag",

  -- command palette theme: dropdown (window) or ivy (bottom panel)
  command_palette_theme = "dropdown",

  -- tag list theme:
  -- get_cursor: small tag list at cursor; ivy and dropdown like above
  show_tags_theme = "ivy",

  -- when linking to a note in subdir/, create a [[subdir/title]] link
  -- instead of a [[title only]] link
  subdirs_in_links = true,

  -- template_handling
  -- What to do when creating a new note via `new_note()` or `follow_link()`
  -- to a non-existing note
  -- - prefer_new_note: use `new_note` template
  -- - smart: if day or week is detected in title, use daily / weekly templates (default)
  -- - always_ask: always ask before creating a note
  template_handling = "always_ask",

  -- path handling:
  --   this applies to:
  --     - new_note()
  --     - new_templated_note()
  --     - follow_link() to non-existing note
  --
  --   it does NOT apply to:
  --     - goto_today()
  --     - goto_thisweek()
  --
  --   Valid options:
  --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
  --              all other ones in home, except for notes/with/subdirs/in/title.
  --              (default)
  --
  --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
  --                    except for notes with subdirs/in/title.
  --
  --     - same_as_current: put all new notes in the dir of the current note if
  --                        present or else in home
  --                        except for notes/with/subdirs/in/title.
  new_note_location = "smart",

  -- should all links be updated when a file is renamed
  rename_update_links = true,

  -- vaults = {
  --     vault2 = {
  --         -- alternate configuration for vault2 here. Missing values are defaulted to
  --         -- default values from telekasten.
  --         -- e.g.
  --         -- home = "/home/user/vaults/personal",
  --     },
  -- },

  -- how to preview media files
  -- "telescope-media-files" if you have telescope-media-files.nvim installed
  -- "catimg-previewer" if you have catimg installed
  media_previewer = "telescope-media-files",

  -- A customizable fallback handler for urls.
  follow_url_fallback = nil,
})

lvim.builtin.which_key.mappings["n"] = {
  name = "Notes",
  c = { "<cmd>Telekasten show_calendar<cr>", "Calendar" },
  n = { "<cmd>Telekasten new_note<cr>", "Note" },
  f = { "<cmd>Telekasten find_notes<cr>", "Find" },
  F = { "<cmd>Telekasten find_daily_notes<cr>", "Find Journal" },
  j = { "<cmd>Telekasten goto_today<cr>", "Journal" },
  p = { "<cmd>Telekasten panel<cr>", "Panel" },
  t = { "<cmd>Telekasten toggle_todo<cr>", "Toggle Todo" },
}
