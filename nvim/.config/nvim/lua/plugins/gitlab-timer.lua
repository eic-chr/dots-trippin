return {
  "eic-chr/gitlab-timer.nvim", -- Setze hier den korrekten GitHub/GitLab-Pfad ein!
  name = "gitlab-timer.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "GitlabTimer",
    "GitlabTimerStart",
    "GitlabTimerStop",
    "GitlabTimerStatus",
    "GitlabTimerAdd",
    "GitlabTimerDebug",
    "GitlabTimerTest",
    "GitlabTimerEntries",
    "GitlabTimerSubgroup",
    "GitlabTimerClearSubgroup",
  },
  keys = {
    { "<leader>gt", "<cmd>GitlabTimer<cr>", desc = "GitLab Timer" },
    { "<leader>gs", "<cmd>GitlabTimerStart<cr>", desc = "Start Timer" },
    { "<leader>gS", "<cmd>GitlabTimerStop<cr>", desc = "Stop Timer" },
  },
  opts = {
    debug_logging = true,
    gitlab_url = "https://gitlab.dev.ewolutions.de",
    group_id = "ewolutions",
  },
}
