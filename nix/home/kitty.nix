{
  pkgs,
  hasPlasma ? false,
  ...
}: {
  programs.kitty = {
    enable = true;
    font.name = "MesloLGS NF";
    font.size = 14.0;
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
      mode = "enabled"; # oder "no-cursor", "no-complete", "no-title" etc.
    };

    # KEYBOARD SHORTCUTS (leer - alles über extraConfig)
    keybindings =
      {
        # Keybindings
        "ctrl+shift+f2" = "edit_config_file";
        "ctrl+shift+f5" = "load_config_file";
        # === FENSTER NAVIGATION (vim-style) ===
        "alt+h" = "neighboring_window left";
        "alt+j" = "neighboring_window down";
        "alt+k" = "neighboring_window up";
        "alt+l" = "neighboring_window right";

        # === FENSTER MANAGEMENT ===
        "alt+enter" = "new_window";
        "alt+w" = "close_window";
        "alt+m" = "toggle_maximized";

        # Fenster verschieben (vim-style)
        "alt+shift+h" = "move_window left";
        "alt+shift+j" = "move_window down";
        "alt+shift+k" = "move_window up";
        "alt+shift+l" = "move_window right";

        # === LAYOUT MANAGEMENT ===
        "alt+space" = "next_layout";
        "alt+shift+space" = "last_used_layout";
        "alt+1" = "goto_layout tall";
        "alt+2" = "goto_layout stack";
        "alt+3" = "goto_layout fat";
        "alt+4" = "goto_layout grid";
        "alt+5" = "goto_layout horizontal";
        "alt+6" = "goto_layout vertical";

        # === TAB MANAGEMENT ===
        "alt+t" = "new_tab";
        "alt+shift+w" = "close_tab";

        # Tab Navigation
        "alt+tab" = "next_tab";
        "alt+shift+tab" = "previous_tab";
        "alt+comma" = "previous_tab"; # Alternative
        "alt+period" = "next_tab"; # Alternative

        # Tab verschieben
        "alt+shift+comma" = "move_tab_backward";
        "alt+shift+period" = "move_tab_forward";

        # === SCROLLING (vim-safe) ===
        "alt+u" = "scroll_page_up";
        "alt+d" = "scroll_page_down";
        "alt+g" = "scroll_home";
        "alt+shift+g" = "scroll_end";

        # === SUCHE ===
        "alt+f" = "show_scrollback";

        # === FENSTER GRÖSSE ===
        "alt+equal" = "resize_window wider 5";
        "alt+minus" = "resize_window narrower 5";
        "alt+shift+equal" = "resize_window taller 5";
        "alt+shift+minus" = "resize_window shorter 5";
        "alt+0" = "reset_window_sizes";

        # "Fill"-ähnliche Funktionen
        "ctrl+alt+f" = "toggle_maximized";
        "ctrl+alt+r" = "reset_window_sizes";

        # Multi-Monitor Support
        "ctrl+shift+1" = "detach_window new-tab";
        "ctrl+shift+2" = "detach_window";
        "ctrl+shift+3" = "detach_tab";
      }
      // (
        if hasPlasma
        then {
          # Linux shortcuts (Ctrl-based)
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";
          "ctrl+plus" = "change_font_size all +2.0";
          "ctrl+minus" = "change_font_size all -2.0";
          "ctrl+0" = "change_font_size all 0";

          # Fenster Größe ändern (Linux)
          "ctrl+alt+h" = "resize_window narrower 5";
          "ctrl+alt+l" = "resize_window wider 5";
          "ctrl+alt+k" = "resize_window taller 5";
          "ctrl+alt+j" = "resize_window shorter 5";
        }
        else {
          # macOS shortcuts (Cmd-based)
          "cmd+c" = "copy_to_clipboard";
          "cmd+v" = "paste_from_clipboard";
          "cmd+plus" = "change_font_size all +2.0";
          "cmd+minus" = "change_font_size all -2.0";
          "cmd+0" = "change_font_size all 0";

          # Fenster Größe ändern (macOS)
          "cmd+alt+h" = "resize_window narrower 5";
          "cmd+alt+l" = "resize_window wider 5";
          "cmd+alt+k" = "resize_window taller 5";
          "cmd+alt+j" = "resize_window shorter 5";
        }
      );
    settings = {
      disable_ligatures = "never";
      term = "xterm-256color";

      macos_quit_when_last_window_closed = true;
      macos_traditional_fullscreen = false;
      macos_option_as_alt = false;
      text_composition_strategy = "platform";
      enable_audio_bell = false;
      initial_window_width = "160c";
      initial_window_height = "48c";
      background_opacity = "0.8";
      dynamic_background_opacity = true;
      hide_window_decorations = "yes";
      cursor_shape = "block";
      cursor_blink_interval = "0.6";
      window_padding_width = "10";

      # EDITOR (dynamischer Pfad über Nix)
      editor = "${pkgs.neovim}/bin/nvim"; # Nix managed neovim

      # ALLE STANDARD-SHORTCUTS LÖSCHEN
      clear_all_shortcuts = "yes";

      # TAB BAR (erweiterte Tab-Titel Optionen)
      tab_bar_min_tabs = 2;
      tab_bar_margin_width = 4;
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";

      # VERSCHIEDENE TAB-TITEL OPTIONEN (wähle eine):

      # Option 1: Host + Programm (gut für SSH)
      tab_title_template = "{index}: {title.split('@')[1].split(':')[0] if '@' in title else title.split(':')[0]}";

      # Option 2: Nur aktuelles Verzeichnis + Programm
      # tab_title_template = "{index}: {title.split('/')[-1]}";

      # Option 3: Layout + vereinfachter Titel
      # tab_title_template = "[{layout_name[:1].upper()}] {title.split('/')[-1] if '/' in title else title}";

      # Option 4: Alles (für debugging)
      # tab_title_template = "{index}|{layout_name[:1]}|{num_windows}w|{title}";

      # Option 5: Minimalistisch (nur Programm/Verzeichnis)
      # tab_title_template = "{title.split(': ')[-1] if ': ' in title else title.split('/')[-1]}";

      tab_bar_background = "none";
      active_tab_foreground = "#000";
      active_tab_background = "#eee";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#444";
      inactive_tab_background = "#999";
      inactive_tab_font_style = "normal";

      # LAYOUT SETTINGS
      enabled_layouts = "tall,stack,fat,grid,horizontal,vertical";

      # WINDOW SETTINGS
      remember_window_size = "yes";
      window_resize_step_cells = 2;
      window_resize_step_lines = 2;

      # PERFORMANCE
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # MOUSE
      strip_trailing_spaces = "smart";

      # KITTY MOD (ändert Standard-Shortcuts)
      kitty_mod = "ctrl+shift"; # Statt cmd+shift, um Globe zu vermeiden
    };
  };

  # Deine bestehende open-actions.conf
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
