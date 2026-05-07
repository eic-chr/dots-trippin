{...}: {
  programs.nixvim = {
    plugins.todo-comments.enable = true;
    keymaps = [
      # ── TODO Comments ────────────────────────────────────────────────────────
      {
        key = "]t";
        action = "<cmd>lua require('todo-comments').jump_next()<cr>";
        options.desc = "Next TODO";
      }
      {
        key = "[t";
        action = "<cmd>lua require('todo-comments').jump_prev()<cr>";
        options.desc = "Prev TODO";
      }
    ];
  };
}
