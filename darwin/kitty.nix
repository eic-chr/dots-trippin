
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "MesloLGS NF";
    font.size = 16.0;
    settings = {
      initial_window_width = "160c";  # z. B. 160 columns
      initial_window_height = "48c";  # z. B. 48 rows
      background_opacity = "0.9";
      hide_window_decorations = "yes";
      cursor_shape = "block";
      cursor_blink_interval = "0.6";
      window_padding_width = "10";
    };
  };

}
