{ programs, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "agnoster";
    oh-my-zsh.plugins = [ "git" "sudo" "mvn" "npm" "ssh" ];
    shellAliases = {
      ls = "eza";
      l = "eza -la";
      tree = "eza --tree";
      cat = "bat";
      make = "gmake";
      docker-compose = "docker compose";
      mmake = "gmake -j$(sysctl -n hw.ncpu)";
    };
#    plugins = [ (import ../nixpkgs/fzf-tab.nix { inherit pkgs; }) ];
    initExtra = lib.readFile ./initExtra.sh;
  };
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = false;
  programs.atuin.enable = false;
#  programs.starship = {
#    enable = true;
#    settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
#  };
}
