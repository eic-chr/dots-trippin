{ programs, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    shellAliases = {
      ls = "${pkgs.eza}/bin/exa";
      l = "${pkgs.eza}/bin/exa -la";
      tree = "${pkgs.eza}/bin/exa --tree";
      cat = "${pkgs.bat}/bin/bat";
      mmake = "${pkgs.gnumake}/bin/make -j$(${pkgs.coreutils}/bin/nproc)";
      garbage = "nix-collect-garbage -d && doas nix-collect-garbage -d";
    };
    plugins = [ (import ../nixpkgs/fzf-tab.nix { inherit pkgs; }) ];
    initExtra = ''
      if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
          source "$EAT_SHELL_INTEGRATION_DIR/zsh"
      fi
    '';
  };
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.atuin.enable = true;
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (lib.readFile ../starship/starship.toml);
  };
  programs.wezterm = {
    enable = true;
    extraConfig = lib.readFile ../wezterm.lua;
  };
}
