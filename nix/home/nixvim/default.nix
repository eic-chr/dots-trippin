{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./core.nix
    ./ui.nix
    ./snacks.nix
    ./git.nix
    ./lsp.nix
    ./completion.nix
    ./misc.nix

    # Additional modules migrated from legacy config
    ./conform.nix
    ./lint.nix
    # ./writing.nix
    ./codecompanion.nix

    ./whichkey.nix
    ./keymaps.nix
    ./lua-config.nix
    # ./zk.nix
  ];
}
