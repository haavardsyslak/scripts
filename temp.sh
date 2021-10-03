#!/usr/bin/sh
cpu_temp=$(sensors | grep "Package" | awk '{print $4}' | sed -e 's/^\+//g' -e 's/\.0//g')

gpu_temp=$(nvidia-smi -q -d temperature | grep "GPU Current Temp" | awk '{print $5,"°C"}' | tr -d " ")

echo "CPU temp: $cpu_temp"
echo "GPU temp: $gpu_temp"
