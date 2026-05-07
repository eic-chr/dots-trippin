{pkgs,...}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      formatOnSave = {
        enable = true;  # Autoformat beim Speichern!
        timeoutMs = 500;
      };
      settings = {
        formatters_by_ft = {
          asciidoc = ["prettier"];
          javascript = ["prettier"];
          typescript = ["prettier"];
          javascriptreact = ["prettier"];
          typescriptreact = ["prettier"];
          css = ["prettier"];
          html = ["prettier"];
          json = ["prettier"];
          yaml = ["prettier"];
          markdown = ["prettier"];
          lua = ["stylua"];
          python = ["isort" "black"];
          nix = ["alejandra"];
        };
      };
    };
    extraPackages = with pkgs; [
      nixfmt
      stylua
      nodePackages.prettier
    ];
    keymaps = [
      {
        key = "<leader>f";
        mode = ["n" "v"];
        action = "<cmd>lua require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 1000 })<CR>";
        options.desc = "Format file or range";
      }
    ];
  };
}
