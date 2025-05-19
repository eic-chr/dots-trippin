{ username, pkgs, ... }:

{

  imports = [
    ./zsh.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.password-store = {
    enable = true;
  };

  home.sessionVariables.GIT_EDITOR = "${pkgs.lunarvim}/bin/lvim";

  home.file.".p10k.zsh".source = ../p10k-config/.p10k.zsh;
  home.file.".oh-my-zsh/custom/themes/powerlevel10k".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
  #home.file.".zshrc".source = ../zsh-zgenom/.zshrc;
}
