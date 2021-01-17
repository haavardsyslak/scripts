#!/usr/bin/sh

nvidia-smi -q -d temperature | grep "GPU Current Temp" | awk '{print $5,"°C"}' | tr -d " "
