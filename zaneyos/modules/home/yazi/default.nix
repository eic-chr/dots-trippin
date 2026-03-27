{pkgs, ...}: let
  settings = import ./yazi.nix;
  keymap = import ./keymap.nix;
  theme = import ./theme.nix;
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    inherit settings;
    inherit keymap;
    inherit theme;
    plugins = {
      inherit (pkgs.yaziPlugins) lazygit;
      inherit (pkgs.yaziPlugins) full-border;
      inherit (pkgs.yaziPlugins) git;
      inherit (pkgs.yaziPlugins) smart-enter;
    };

    initLua = ''
      require("full-border"):setup()
         require("git"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';
  };
}
