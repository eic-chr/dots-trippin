#!/usr/bin/env bash

# folders that should, or only need to be installed for a local user
base=(
    git
    brew
    lunarvim
    zsh
    vim
    tmux

)

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2
    # -v verbose
    # -R recursive
    # -t target
    stow -v -R -t ${usr} ${app}
}

echo ""
echo "Stowing apps for user: ${whoami}"

# install apps available to local users and root
for app in ${base[@]}; do
    stowit "${HOME}" $app 
done

echo ""
echo "##### ALL DONE"

