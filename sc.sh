#!/usr/bin/sh

file=$(fd . -t f $HOME/programering/scripts | fzf)

$EDITOR $file
