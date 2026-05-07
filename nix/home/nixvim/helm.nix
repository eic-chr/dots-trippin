{pkgs,...}: {
  programs.nixvim = {
    plugins = {
      helm.enable = true;
      lsp = {
        enable = true;

        servers = {
          helm_ls.enable = true;
        };
      };
      treesitter = {
        enable = true;
        settings.ensure_installed = [ "helm" ];
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      helm-ls-nvim 
    ];

    autoCmd = [
      {
        event = "FileType";
        pattern = "helm";
        command = "LspRestart";
      }
    ];
  };
}
