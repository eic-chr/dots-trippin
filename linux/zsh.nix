{ programs, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    shellAliases = {
      ls = "${pkgs.eza}/bin/exa";
      l = "${pkgs.eza}/bin/exa -la";
      tree = "${pkgs.eza}/bin/exa --tree";
      cat = "${pkgs.bat}/bin/bat";
      vi = "${pkgs.lunarvim}/bin/lvim";
      mmake = "${pkgs.gnumake}/bin/make -j$(${pkgs.coreutils}/bin/nproc)";
      garbage = "nix-collect-garbage -d && doas nix-collect-garbage -d";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
# plugins = [ (import ../nixpkgs/fzf-tab.nix { inherit pkgs; }) ];
# initExtra = ''
#   if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
#       source "$EAT_SHELL_INTEGRATION_DIR/zsh"
#   fi
# '';
  };
                              }
