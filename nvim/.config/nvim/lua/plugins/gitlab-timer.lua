return {
  {
    -- dir = "/home/christian/projects/ceickhoff/gitlab-timer.nvim",
    name = "gitlab-timer.nvim",
    main = "gitlab-timer", -- ruft require("gitlab-timer").setup(opts) auf
    config = true, -- nutzt die unten definierten opts
    -- dev = true, -- kennzeichnet es als lokales Dev-Plugin

    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      gitlab_url = "https://gitlab.dev.ewolutions.de",
      gitlab_token = "glpat-KW2ZXRFvHTcnvQoZCeUTQG86MQp1OjcH.01.0w1553wjx",
      debug_logging = true,
      group_id = "ewolutions",
    },
    keys = {
      {
        "<leader>gt",
        function()
          require("gitlab-timer").show_menu()
        end,
        desc = "GitLab Timer",
      },
      {
        "<leader>gs",
        function()
          require("gitlab-timer").start_timer()
        end,
        desc = "Start Timer",
      },
      {
        "<leader>gS",
        function()
          require("gitlab-timer").stop_timer()
        end,
        desc = "Stop Timer",
      },
    },
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
  },
}
