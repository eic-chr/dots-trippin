export PATH="/usr/local/opt/m4/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
#export PATH="/usr/local/opt/gnupg/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export NIXPKGS_ALLOW_UNFREE=1


MVN_BIN=$(command -v mvn)
function mvn () {
    if [ -f "./mvnw" ]; then
        >&2 echo "Using local ./mvnw"
        ./mvnw $@
    else
        $MVN_BIN $@
    fi
}

if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Lade nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Lade nvm bash_completion (optional)

source <(fzf --zsh)
source $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"
bindkey -v
