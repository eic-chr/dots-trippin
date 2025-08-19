-- lua/rot13.lua
local M = {}

local function rot13(str)
  return str:gsub("[%a]", function(c)
    local base = c:match("%l") and string.byte("a") or string.byte("A")
    return string.char((string.byte(c) - base + 13) % 26 + base)
  end)
end

local function rot13_encode_html(opts)
  -- Prüfe ob es einen range gibt (Visual Mode oder :ROT13Encode mit range)
  if opts.range > 0 then
    -- Range mode: Verwende die übergebenen Zeilen
    local start_line = opts.line1 - 1  -- 0-basiert für nvim_buf_*
    local end_line = opts.line2 - 1    -- 0-basiert für nvim_buf_*
    
    -- Hole die Zeilen im angegebenen Bereich
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
    
    -- Verschlüssele jede Zeile
    local encrypted_lines = {"<!-- ROT ENCODED -->"}
    for _, line in ipairs(lines) do
      encrypted_lines[#encrypted_lines + 1] = rot13(line)
    end
    encrypted_lines[#encrypted_lines + 1] = "<!-- /ROT -->"
    
    -- Ersetze die ursprünglichen Zeilen mit den verschlüsselten
    vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, encrypted_lines)
    
  else
    -- Normal mode: Arbeite mit der aktuellen Zeile
    local current_line = vim.fn.line(".") - 1  -- 0-basiert
    local line = vim.api.nvim_get_current_line()
    
    local encrypted_lines = {
      "<!-- ROT ENCODED -->",
      rot13(line),
      "<!-- /ROT -->",
    }
    
    -- Ersetze die aktuelle Zeile
    vim.api.nvim_buf_set_lines(0, current_line, current_line + 1, false, encrypted_lines)
  end
end

local function rot13_decode_html()
  local current_line = vim.fn.line(".") - 1  -- 0-basiert (wo der Cursor steht)
  
  -- Hole alle Zeilen
  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Finde alle ROT-Blöcke
  local blocks = {}
  local i = 1
  while i <= #all_lines do
    if all_lines[i] == "<!-- ROT ENCODED -->" then
      -- Suche das Ende dieses Blocks
      for j = i + 1, #all_lines do
        if all_lines[j] == "<!-- /ROT -->" then
          blocks[#blocks + 1] = {
            start_line = i - 1,  -- 0-basiert
            end_line = j - 1     -- 0-basiert
          }
          i = j + 1
          break
        end
      end
    else
      i = i + 1
    end
  end
  
  if #blocks == 0 then
    vim.notify("No ROT HTML comment blocks found", vim.log.levels.INFO)
    return
  end
  
  -- Finde den Block, der die aktuelle Cursor-Position enthält oder der nächstgelegene
  local target_block = nil
  
  -- Erst prüfen: Ist der Cursor in einem Block?
  for _, block in ipairs(blocks) do
    if current_line >= block.start_line and current_line <= block.end_line then
      target_block = block
      break
    end
  end
  
  -- Falls nicht in einem Block, nimm den nächstgelegenen
  if not target_block then
    local min_distance = math.huge
    for _, block in ipairs(blocks) do
      local distance = math.min(
        math.abs(current_line - block.start_line),
        math.abs(current_line - block.end_line)
      )
      if distance < min_distance then
        min_distance = distance
        target_block = block
      end
    end
  end
  
  -- Hole die verschlüsselten Zeilen (zwischen den Kommentaren)
  local encrypted_lines = vim.api.nvim_buf_get_lines(0, target_block.start_line + 1, target_block.end_line, false)
  
  -- Entschlüssele sie
  local decoded_lines = {}
  for _, line in ipairs(encrypted_lines) do
    decoded_lines[#decoded_lines + 1] = rot13(line)
  end
  
  -- Ersetze den gesamten Block (inklusive Kommentare) mit den entschlüsselten Zeilen
  vim.api.nvim_buf_set_lines(0, target_block.start_line, target_block.end_line + 1, false, decoded_lines)
  
  vim.notify("ROT13 block decoded", vim.log.levels.INFO)
end

function M.setup()
  vim.api.nvim_create_user_command("ROT13Encode", rot13_encode_html, { range = true })
  vim.api.nvim_create_user_command("ROT13Decode", rot13_decode_html, {})
end

return M