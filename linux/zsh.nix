{ lib, pkgs, ... }: {
#   programs.zsh = {
#     enable = true;
# # initExtra = lib.readFile ./initExtra.sh;
#     enableAutosuggestions = false;
#     shellAliases = {
#       ls = "${pkgs.eza}/bin/exa";
#       l = "${pkgs.eza}/bin/exa -la";
#       tree = "${pkgs.eza}/bin/exa --tree";
#       cat = "${pkgs.bat}/bin/bat";
#       vi = "${pkgs.lunarvim}/bin/lvim";
#       mmake = "${pkgs.gnumake}/bin/make -j$(${pkgs.coreutils}/bin/nproc)";
#       garbage = "nix-collect-garbage -d && doas nix-collect-garbage -d";
#     };
#     oh-my-zsh = {
#       enable = true;
#       plugins = [ "git" ];
#       theme = "robbyrussell";
#     };
#   };
#                     }
