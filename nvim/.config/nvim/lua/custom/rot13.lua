-- lua/rot13.lua
local M = {}

local function rot13(str)
  return str:gsub("[%a]", function(c)
    local base = c:match("%l") and string.byte("a") or string.byte("A")
    return string.char((string.byte(c) - base + 13) % 26 + base)
  end)
end

local function rot13_encode_html()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    local start_pos = vim.fn.getpos("'<")[2]
    local end_pos = vim.fn.getpos("'>")[2]
    local lines = vim.fn.getline(start_pos, end_pos)
    if type(lines) == "string" then
      lines = { lines }
    end
    local encrypted = vim.tbl_map(rot13, lines)
    table.insert(encrypted, 1, "<!-- ROT ENCODED -->")
    table.insert(encrypted, "<!-- /ROT -->")
    vim.fn.setline(start_pos, encrypted)
    if end_pos > start_pos then
      vim.fn.setline(end_pos + 1, "")
    end
  else
    local line = vim.api.nvim_get_current_line()
    local encrypted = {
      "<!-- ROT ENCODED -->",
      rot13(line),
      "<!-- /ROT -->",
    }
    vim.api.nvim_buf_set_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), false, encrypted)
  end
end

local function rot13_decode_html()
  local line_nr = vim.fn.line(".") - 1
  local lines = vim.api.nvim_buf_get_lines(0, line_nr, line_nr + 3, false)
  if lines[1] == "<!-- ROT ENCODED -->" and lines[3] == "<!-- /ROT -->" then
    local decrypted = rot13(lines[2])
    vim.api.nvim_buf_set_lines(0, line_nr, line_nr + 3, false, { decrypted })
  else
    vim.notify("No ROT HTML comment block found", vim.log.levels.INFO)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("ROT13Encode", rot13_encode_html, { range = true })
  vim.api.nvim_create_user_command("ROT13Decode", rot13_decode_html, {})
end

return M
