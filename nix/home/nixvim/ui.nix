{ ... }:

{
  programs.nixvim = {
    plugins = {
      web-devicons.enable = true;

      lualine = {
        enable = true;
        settings.options.theme = "kanagawa";
      };

      bufferline.enable = true;
      flash.enable = true;
    };

    colorschemes.kanagawa = {
      enable = true;
      autoLoad = true;
      settings = {
        theme = "wave";
        background = {
          dark = "wave";
          light = "lotus";
        };
      };
    };
  };
}
