#!/usr/bin/sh

b=$(ps ux | grep "ckb-next" | grep -v -c "grep")
#done
while [ $b -eq "0" ]
do 
	b=$(ps ux | grep "ckb-next" | grep -v -c "grep")
    sleep .1
done

echo $b
sleep .5
xdotool key alt+q  
