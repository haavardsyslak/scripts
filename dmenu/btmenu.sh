#!/usr/bin/sh

boom_mac_adr="C0:28:8D:F1:1A:E1"
bose_mac_adr="C8:7B:23:0B:ED:F4"
device=$(printf "boom\nbose" | dmenu)

case $device in
    "boom")
        bluetoothctl connect $boom_mac_adr
        ;;
    "bose")
        bluetoothctl connect $bose_mac_adr
        ;;
esac
