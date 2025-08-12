return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = function()
    local file_dir = vim.fn.expand("%:p:h") -- aktuelles Dateiverzeichnis
    local cwd = vim.fn.getcwd() -- Projekt-Root
    local dir_path

    if vim.fn.isdirectory(file_dir .. "/images") == 1 then
      dir_path = file_dir .. "/images"
    elseif vim.fn.isdirectory(cwd .. "/images") == 1 then
      dir_path = cwd .. "/images"
    else
      dir_path = cwd .. "/images"
      vim.fn.mkdir(dir_path, "p")
    end

    return {
      default = {
        dir_path = dir_path,
        file_name = "%Y-%m-%d-%H-%M-%S",
        extension = "png",
        template = "![$FILE_NAME]($FILE_PATH)",
      },
    }
  end,
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
