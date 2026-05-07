{ pkgs, ... }:
let
  outline-asciidoc-provider = pkgs.vimUtils.buildVimPlugin {
    pname = "outline-asciidoc-provider";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "msr1k";
      repo = "outline-asciidoc-provider.nvim";
      rev = "main";
      sha256 = "sha256-J9yUv1h1stT+W9uq7G2MuO/YWO8m7WO9MDTSdV9s32o=";
    };
  };
in {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      outline-asciidoc-provider
      outline-nvim
    ];

    extraConfigLua = ''
      -- Outline.nvim Setup
      require("outline").setup({
        providers = {
          priority = { 'lsp', 'coc', 'markdown', 'norg', 'asciidoc' },
        },
        outline_window = {
          position = "right",
          width = 30,
          relative = "editor",  -- An Editor-Rand ausrichten
        },
        symbols = {
          autoPreview = false,  -- Preview nur bei Klick
        },
        win_position = {
          width = 30,           -- Sidebar-Breite
        },
        preview_window = {
          auto_preview = false,
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>oo", "<cmd>Outline<CR>", {
        desc = "Toggle Outline Sidebar (rechts)"
      })
    '';
  };
}
