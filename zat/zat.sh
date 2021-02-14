#!/usr/bin/bash
fag=$(cat $HOME/programering/scripts/zat/fag | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}')

echo $fag
case $fag in
    "STA100")
        echo "asd"
        file=$(cat $HOME/programering/scripts/zat/STA100 | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}')
        ;;
    "ELE100")
        file=$(cat $HOME/programering/scripts/zat/ELE100 | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}')
        ;;
    "DAT100")
        file=$(cat $HOME/programering/scripts/zat/DAT100 | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}')
        ;;
esac
#file=$(cat $HOME/programering/scripts/dmenu/files | dmenu -i -l 20 -fn Monospace-12 | awk '{print $1}')
echo $file

zathura $file


