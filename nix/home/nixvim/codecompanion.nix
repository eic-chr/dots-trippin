{...}: {
  programs.nixvim = {
    plugins.codecompanion = {
      enable = true;

      settings = {
        strategies = {
          chat.adapter = "openai";
          inline.adapter = "openai";
        };
      };
    };

    keymaps = [
      {
        key = "<leader>aa";
        action = "<cmd>CodeCompanionChat Toggle<cr>";
        mode = ["n" "v"];
        options.desc = "Chat Toggle";
      }
      {
        key = "<leader>ai";
        action = "<cmd>CodeCompanion<cr>";
        mode = ["n" "v"];
        options.desc = "Inline Assist";
      }
      {
        key = "<leader>ap";
        action = "<cmd>CodeCompanionActions<cr>";
        mode = ["n" "v"];
        options.desc = "Actions";
      }
    ];
  };
}
