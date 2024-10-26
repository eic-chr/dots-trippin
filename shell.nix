# shell.nix - use for initial bootstrapping
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.stow  # Example: Python 3.9
    pkgs.git       # Example: Git
    pkgs.zsh
  ];
}

