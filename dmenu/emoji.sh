#!/bin/sh

grep -v "#" ~/programering/scripts/dmenu/unicode | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
