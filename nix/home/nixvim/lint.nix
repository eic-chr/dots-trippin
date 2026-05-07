{ ... }:

{
  programs.nixvim.plugins.lint = {
    enable = true;

    lintersByFt = {
      nix = [ "statix" ];
      asciidoc = [ "vale" ];
      markdown = [ "vale" ];
    };
  };
}
