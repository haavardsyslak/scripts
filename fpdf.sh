#!/bin/sh

dir="${1:-$HOME/ntnufiles/}"

if [ ! -d "$dir" ]; then
    echo 'No such directory: "$dir"'
    exit 1
fi

file=$(find "$dir" -type f -iname "*.pdf" | fzf)

echo $file

if [ -n "$file" ]; then
   nohup zathura "$file" > /dev/null 2>&1 &
fi
