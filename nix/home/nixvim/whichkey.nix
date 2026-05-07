{...}: {
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      win = {
        width.max = 45;
        height = {
          min = 4;
          max = 25;
        };
        border = "rounded";
      };
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "diagnostics";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "find/files";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
        }
        {
          __unkeyed-1 = "<leader>gh";
          group = "hunks";
        }
        {
          __unkeyed-1 = "<leader>o";
          group = "overseer/scratch";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "quit/session";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "search";
        }
        {
          __unkeyed-1 = "<leader>sn";
          group = "noice";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui/toggle";
        }
        {
          __unkeyed-1 = "<leader>z";
          group = "zettelkasten";
        }
        {
          __unkeyed-1 = "<leader>zn";
          group = "new note";
        }
        {
          __unkeyed-1 = "<leader>zo";
          group = "open/browse";
        }
        {
          __unkeyed-1 = "<leader>dt";
          desc = "Diagnostics (Trouble)";
        }
        {
          __unkeyed-1 = "<leader>st";
          desc = "TODOs (Trouble)";
        }
      ];
    };
  };
}
