export PATH="/usr/local/opt/node@12/bin:$PATH"
export PATH="/usr/local/opt/m4/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
#export PATH="/usr/local/opt/gnupg/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="/usr/local/bin:$PATH"

WORKSPACE=$HOME/projects/hsp-event-platform

function kafkactx () {
    if [ -n "$1" ]; then
	kafkactl config use-context $1
    else
	kafkactl config use-context $(kafkactl config get-contexts -o compact | fzf --preview 'kafkactl config view | yq -C '.contexts.{}'')
    fi
}

# brew
if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    alias emacs="$EMACS -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi

# ports
if [ -f "/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs"
    alias emacs="$EMACS -nw"
fi

if [ -f "/Applications/MacPorts/EmacsMac.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/bin/emacsclient"
fi

# Nix + Symlink
if [ -h "$HOME/Applications/Emacs.app" ]; then
    export EMACS="$HOME/Applications/Emacs.app/Contents/MacOS/Emacs"
    alias emacs="$EMACS -nw"
fi

export EDITOR="$EMACS -nw"
export VISUAL=$EMACS

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

kafkactl completion zsh > "${fpath[1]}/_kafkactl"
