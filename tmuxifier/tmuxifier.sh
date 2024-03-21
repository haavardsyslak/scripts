#/usr/bin/sh

# mostly copied from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

if [[ "$1" == "a" ]]; then 
    session_name=$(tmux list-sessions -F "#{session_name}" | fzf --reverse --height 20)
    session_dir=$(pwd)
    if [[ -z "$session_name" ]]; then
        exit
    fi
elif [[ -n "$1" ]]; then
    session_name=$(basename "$1" | tr . _)
    session_dir=$(pwd)
else
    #session_dir=$(| fzf --reverse --height 20)
    session_dir=$( { fd . $HOME --type d --exclude Zotero --exclude Downloads --exclude Pictures --max-depth 2 --min-depth 1;  fd . $HOME/.config --max-depth 1; } | fzf --reverse --height 20)
    session_name=$(basename "$session_dir" | tr . _)
fi

if [[ -z "$session_dir" ]]; then
    exit
fi

tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $session_name  -c $session_dir
    exit 0
fi

if ! tmux has-session -t=$session_name 2> /dev/null; then
    tmux new-session -ds $session_name -c $session_dir
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $session_name
else
    tmux switch-client -t $session_name
fi

