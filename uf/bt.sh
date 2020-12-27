#!/usr/bin/sh

coproc bluetoothctl
echo -e 'power on\n agent on\n scan on' >&${COPROC[1]}
output=$(cat <&${COPROC[0]})
echo $output
