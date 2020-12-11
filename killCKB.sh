#!/usr/bin/sh

	
b=$(ps ux | grep "ckb-next" | grep -v -c "grep")
#done
echo $b
while [ $b -eq "0" ]
do 
	b=$(ps ux | grep "ckb-next" | grep -v -c "grep")
done

echo $e
xdotool key alt+q  
