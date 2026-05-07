{ config, pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      trouble.enable = true;
      colorizer.enable = true;
      markdown-preview.enable = true;
      project-nvim.enable = true;

      persistence = {
        enable = true;
        settings.dir = "${config.xdg.dataHome}/nvim/sessions/";
      };

      auto-save = {
        enable = true;
        settings = {
          enabled = true;
          write_all_buffers = false;
          debounce_delay = 1000;
        };
      };

      treesitter.enable = true;
      treesitter-context.enable = false;

      overseer = {
        enable = true;
        settings.task_list = {
          direction = "bottom";
          min_height = 10;
        };
      };

      hardtime = {
        enable = true;
        settings.enabled = true;
      };

      img-clip.enable = true;
    };

    extraPackages = with pkgs; [
      ripgrep
      fd
      bat
      wl-clipboard
      xclip
      lazygit
      zk
      nil
      hyprls
      nodePackages.typescript-language-server
      nodePackages.typescript
      vscode-langservers-extracted
      pyright
      lua-language-server
      zls
      marksman
      multimarkdown
      clang-tools
      prettierd
      stylua
      shfmt
      nixpkgs-fmt
    ];
  };
}
