#!/usr/bin/bash
fag=$(cat $HOME/programering/scripts/zat/fag | dmenu -i -l 20 | awk '{print $1}')

case $fag in
    "ELE210")
        file=$(cat $HOME/programering/scripts/zat/ele210 | dmenu -i -l 20 | awk '{print $1}')
        ;;
    "ELE200")
        file=$(cat $HOME/programering/scripts/zat/ele200 | dmenu -i -l 20 | awk '{print $1}')
        ;;
    "MAT100")
        file=$(cat $HOME/programering/scripts/zat/mat100 | dmenu -i -l 20 | awk '{print $1}')
        ;;
    "STA100")
        file=$(cat $HOME/programering/scripts/zat/sta100 | dmenu -i -l 20 | awk '{print $1}')
        ;;
    "ELE100")
        file=$(cat $HOME/programering/scripts/zat/ele100 | dmenu -i -l 20 | awk '{print $1}')
        ;;
    "DAT100")
        file=$(cat $HOME/programering/scripts/zat/ele100 | dmenu -i -l 20 | awk '{print $1}')
        ;;
esac


[ ! -z "$file" ] && zathura $file
