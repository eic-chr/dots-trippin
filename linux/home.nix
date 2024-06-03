
{ config, pkgs, lib, ... }:
let
system = "x86_64-linux";
colorScheme = {
  base00 = "2E3440";
  base01 = "3B4252";
  base02 = "434C5E";
  base03 = "4C566A";
  base04 = "D8DEE9";
  base05 = "E5E9F0";
  base06 = "ECEFF4";
  base07 = "8FBCBB";
  base08 = "BF616A";
  base09 = "D08770";
  base0A = "EBCB8B";
  base0B = "A3BE8C";
  base0C = "88C0D0";
  base0D = "81A1C1";
  base0E = "B48EAD";
  base0F = "5E81AC";
};
in
{
  imports = [
    ./zsh.nix
  ];

# Home Manager needs a bit of information about you and the
# paths it should manage.
  home.username = "christian";
  home.homeDirectory = "/home/christian";

# This value determines the Home Manager release that your
# configuration is compatible with. This helps avoid breakage
# when a new Home Manager release introduces backwards
# incompatible changes.
#
# You can update Home Manager without changing this value. See
# the Home Manager release notes for a list of state version
# changes in each release.
  home.stateVersion = "24.05";

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

###########
# desktop #
###########

#home.file.".zshrc".source = ../zsh-zgenom/.zshrc;
  home.file.".p10k.zsh".source = ../p10k-config/.p10k.zsh;

  programs.alacritty.enable = false;
  programs.alacritty.settings = {
    window = {
      padding = {
        x = 3;
        y = 3;
      };
      dynamic_padding = true;
    };
    dynamic_title = true;
    gtk_theme_variant = "dark";
    font = {
#normal.family = "Hack";
      normal.family = "Berkeley Mono";
      size = 10.0;
    };
    colors = with colorScheme; {
      primary = {
        background = "#${base00}";
        foreground = "#${base04}";
        dim_foreground = "#a5abb6";
      };
      cursor = {
        text = "#${base00}";
        cursor = "#${base04}";
      };
      normal = {
        black = "#${base01}";
        red = "#${base08}";
        green = "#${base0B}";
        yellow = "#${base0A}";
        blue = "#${base0D}";
        magenta = "#${base0E}";
        cyan = "#${base0C}";
        white = "#${base05}";
      };
      bright = {
        black = "#${base03}";
        red = "#${base08}";
        green = "#${base0B}";
        yellow = "#${base0A}";
        blue = "#${base0D}";
        magenta = "#${base0E}";
        cyan = "#${base07}";
        white = "#${base06}";
      };
      selection = { background = "#${base03}"; };
    };
  };
}
