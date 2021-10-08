#!/usr/bin/sh
if [ -d  "/tmp/remarkable" ]; then
    rm -r /tmp/remarkable
fi
mkdir /tmp/remarkable
cd /tmp/remarkable
rmapi -ni mget .
rm2pdf

