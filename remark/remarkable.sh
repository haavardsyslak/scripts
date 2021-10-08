#!/usr/bin/sh
if [ -d  "/tmp/remarkable" ]; then
    rm -r /tmp/remarkable
fi


mkdir /tmp/remarkable
cd /tmp/remarkable
rmapi -ni mget .
rm2pdf

if [ -d "$XDG_CACHE_HOME/remarkable" ]; then
    rm -r $XDG_CACHE_HOME/remarkable
fi

cp -r /tmp/remarkable $XDG_CACHE_HOME/remarkable
