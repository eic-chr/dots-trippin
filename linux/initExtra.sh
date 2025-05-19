source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme;
eval "$(direnv hook zsh)"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
