#!/usr/bin/env bash

devcon_root=$HOME/source
dir=$(pwd)

if [[ $dir == $HOME* ]]; then
    cd_path="/workspaces/${dir#$HOME/}"
fi


# docker exec -it --detach-keys="ctrl-q,ctrl-q" --workdir $cd_path blunux-devcontainer zsh
# =======
# docker exec -it --workdir $cd_path blunux-devcontainer zsh
docker exec -it --workdir $cd_path \
	-e DISPLAY=$DISPLAY \
	--detach-keys="ctrl-\\,ctrl-\\" \
	blunux-devcontainer zsh
# devcontainer exec --workspace-folder=$devcon_root bash -c "cd $cd_path && exec zsh"
