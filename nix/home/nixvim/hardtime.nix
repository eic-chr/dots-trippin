{...}: {
  programs.nixvim = {
    # ── Hardtime (schlechte Gewohnheiten abgewöhnen) ──────────────────────────
    hardtime = {
      enable = true;
      settings = {
        enabled = true;
        disable_mouse = false;
        hint = true;
        notification = true;
        max_count = 4; # wie oft man denselben Key hintereinander drücken darf
        restricted_keys = {
          "h" = ["n" "x"];
          "j" = ["n" "x"];
          "k" = ["n" "x"];
          "l" = ["n" "x"];
        };
      };
    };
  };
}
