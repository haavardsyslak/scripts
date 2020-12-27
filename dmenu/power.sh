#!/usr/bin/sh

cmd=('echo "HI"' 'systemctl suspend' 'systemctl hibernate' 'poweroff' 'reboot')

input=$(cat /home/syslak/programering/scripts/dmenu/power | dmenu -l 4 -fn Monospace-12 | awk '{print $1}')
echo $input

if "$input" = "Sleep"
then
	echo $input
fi
