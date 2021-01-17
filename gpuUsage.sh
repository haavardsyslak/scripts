#!/usr/bin/sh

nvidia-smi -q -d UTILIZATION | grep "Gpu" | awk '{print " : (", $3,"%)"}' | tr -d " "
