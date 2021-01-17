#!/usr/bin/sh
sensors | grep "Package" | awk '{print $4}' | sed -e 's/^\+//g' -e 's/.0//g'
