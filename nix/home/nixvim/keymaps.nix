{ ... }:

{
  programs.nixvim.keymaps = [


    # General
    {
      mode = "n";
      key = "<A-Up>";
      action = "<cmd>resize -2<CR>";
    }
    {
      mode = "n";
      key = "<A-Down>";
      action = "<cmd>resize +2<CR>";
    }
    {
      mode = "n";
      key = "<A-Left>";
      action = "<cmd>vertical resize -2<CR>";
    }
    {
      mode = "n";
      key = "<A-Right>";
      action = "<cmd>vertical resize +2<CR>";
    }
    {
      key = "jk";
      mode = [ "i" ];
      action = "<ESC>";
      options.desc = "Exit insert mode";
    }
    {
      key = "<F1>";
      mode = [ "n" "i" "v" "x" "s" "o" "t" "c" ];
      action = "<Nop>";
      options.desc = "Disable F1";
    }

    # Buffer
    {
      key = "<leader>bd";
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      options.desc = "Delete Buffer";
    }
    {
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options.desc = "Prev Buffer";
    }
    {
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options.desc = "Next Buffer";
    }

    # Git
    {
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "Lazygit";
    }
    {
      key = "<leader>gn";
      action = "<cmd>Neogit<cr>";
      options.desc = "Neogit";
    }
    {
      key = "]h";
      action = "<cmd>Gitsigns next_hunk<cr>";
      options.desc = "Next Hunk";
    }
    {
      key = "[h";
      action = "<cmd>Gitsigns prev_hunk<cr>";
      options.desc = "Prev Hunk";
    }

    # Diagnostics
    {
      key = "<leader>dj";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      options.desc = "Next diagnostic";
    }
    {
      key = "<leader>dk";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      options.desc = "Prev diagnostic";
    }
    {
      key = "<leader>dt";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Toggle diagnostics";
    }

    # Terminal
    {
      key = "<leader>t";
      action = "<cmd>lua Snacks.terminal()<cr>";
      options.desc = "Toggle Terminal";
    }
  ];
}
