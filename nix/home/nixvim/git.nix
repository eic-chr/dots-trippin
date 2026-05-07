{ ... }:

{
  programs.nixvim.plugins = {
    gitsigns = {
      enable = true;
      settings.signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "";
        topdelete.text = "";
        changedelete.text = "▎";
      };
    };

    diffview.enable = true;

    neogit = {
      enable = true;
      settings.integrations.diffview = true;
    };
  };
}
