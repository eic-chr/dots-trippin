
{ config, pkgs, ... }:

{
programs.alacritty = {
  enable = true;

  settings = {
    env = {
      TERM = "xterm-256color";
    };

    window = {
      padding = {
        x = 10;
        y = 10;
      };
      decorations = "buttonless";
      opacity = 0.9;
      blur = true;
      option_as_alt = "Both";
      startup_mode = "Maximized";
    };

    bell = {
      animation = "EaseOutSine";
    };

    font = {
      size = 16.0;
      normal = {
        family = "MesloLGS Nerd Font";
        style = "Medium";
      };
      bold = {
        family = "MesloLGS Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "MesloLGS Nerd Font";
        style = "Italic";
      };
      bold_italic = {
        family = "MesloLGS Nerd Font";
        style = "Bold Italic";
      };
    };

    cursor = {
      style = {
        shape = "Block";
        blinking = "On";
      };
    };

    mouse = {
      hide_when_typing = true;
    };

    general = {
      live_config_reload = true;
      working_directory = "None";
    };
  };
};
}
