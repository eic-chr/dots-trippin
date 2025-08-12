{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "MesloLGS NF";
    font.size = 14.0;
    settings = {
      initial_window_width = "160c";
      initial_window_height = "48c";
      background_opacity = "0.9";
      hide_window_decorations = "yes";
      cursor_shape = "block";
      cursor_blink_interval = "0.6";
      window_padding_width = "10";
      editor = "nvim";
      
      # TAB BAR (Syntax korrigiert)
      tab_bar_min_tabs = 2;
      tab_bar_margin_width = 4;
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      tab_title_template = "{index}";
      tab_bar_background = "none";
      active_tab_foreground = "#000";
      active_tab_background = "#eee";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#444";
      inactive_tab_background = "#999";
      inactive_tab_font_style = "normal";
    };
  };
  
  home.file.".config/kitty/open-actions.conf".text = ''
    protocol file
    mime text/markdown,text/x-markdown
    ext md,markdown,mdown
    action launch --type=os-window nvim ''${FILE_PATH}
    
    protocol file
    mime text/*
    action launch --type=os-window nvim ''${FILE_PATH}
  '';
}
