#!/usr/bin/sh

free -m | grep "Mem" | awk '{printf ": %.0fM", $3; printf "(%.0f",  $3/$2*100; print "%)"}' 

