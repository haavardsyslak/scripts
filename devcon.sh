#!/usr/bin/env bash

devcon_root=$HOME/source
dir=$(pwd)

if [[ $dir == $HOME* ]]; then
    cd_path="/workspaces/${dir#$HOME/}"
fi


devcontainer exec --workspace-folder=$devcon_root bash -c "cd $cd_path && exec zsh"
