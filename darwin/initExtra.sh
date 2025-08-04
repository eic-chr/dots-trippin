# Performance profiling (nur temporär für Tests)
# zmodload zsh/zprof

# PATH exports
export PATH="/usr/local/opt/m4/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH" 
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Environment
export NIXPKGS_ALLOW_UNFREE=1
export EDITOR="nvim"
export PAGER="bat"

# Better history
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Maven wrapper function
MVN_BIN=$(command -v mvn)
function mvn () {
    if [ -f "./mvnw" ]; then
        >&2 echo "Using local ./mvnw"
        ./mvnw $@
    else
        $MVN_BIN $@
    fi
}

# Quick functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git functions
function gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# EAT shell integration
if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"
fi

# FZF with better defaults
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# Powerlevel10k theme
if [[ -f $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Vi mode mit besseren Bindings
bindkey -v
export KEYTIMEOUT=1

# Vi mode cursor shapes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# P10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#
# Performance profiling output (nur für Tests)
# zprof
