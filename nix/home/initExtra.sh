# Performance profiling (nur temporär für tests)
# zmodload zsh/zprof
#
# Automatisch tmux bei SSH (nur interaktiv, eine Session pro Host)
case $- in
  *i*)
    if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
      SESSION="ssh-$(hostname -s)"
      tmux attach -t "$SESSION" || tmux new -s "$SESSION"
    fi
  ;;
esac
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

# FZF wird durch Nix konfiguriert - hier nicht mehr nötig

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

# Better key bindings
# History substring search (von oh-my-zsh plugin)
bindkey '^[[A' history-substring-search-up      # Pfeil hoch
bindkey '^[[B' history-substring-search-down    # Pfeil runter

# FZF widgets (werden von `fzf --zsh` bereitgestellt)
bindkey '^R' fzf-history-widget    # Ctrl+R: Fuzzy history search
bindkey '^T' fzf-file-widget       # Ctrl+T: Fuzzy file finder

# Alternative für fzf-cd-widget (da Alt+C problematisch auf Mac)
bindkey '^F' fzf-cd-widget         # Ctrl+F: Fuzzy directory change
# oder
bindkey '^G' fzf-cd-widget         # Ctrl+G: Fuzzy directory change

_just_completion() {
    if [[ -f "justfile" ]]; then
      local options
      options="$(just --summary)"
      reply=(${(s: :)options})  # turn into array and write to return variable
    fi
}

compctl -K _just_completion just

if [ -f "$HOME/.gitlab-token" ]; then
      export GITLAB_TOKEN=$(cat "$HOME/.gitlab-token")
      export GITLAB_URL="https://gitlab.dev.ewolutions.de"
      export GITLAB_GROUP_ID="ewolutions"
    fi
# Performance profiling output (nur für Tests)
# zprof
