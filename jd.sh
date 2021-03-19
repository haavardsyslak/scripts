#!/usr/bin/fish

function jd() {
    dir=$(fd . -t d $HOME/programering $HOME/.config $HOME/uisfiles | fzf)

    cd $dir
}

jd
