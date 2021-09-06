#!/usr/bin/python3

import os
import sys

path = os.getcwd()
zatPath = os.environ["HOME"] + "/programering/scripts/zat/"

usage = """Usage:    
        add [fag] [filename]"""

args = sys.argv[1:]

if len(args) <= 1:
    print("Not enough argumets provided!") 
    print(usage)
    sys.exit(1)

fag = zatPath + args.pop(0).lower()
# fil = path + "/" + args.pop(0)

if not os.path.isfile(fag):
    print("fag not found")

else:
    toWrite = ""
    for i in args:
        fil = path + "/" + i
        if not os.path.isfile(fil):
            print(fil, " does not exist")
            sys.exit(1)
            continue
        toWrite += fil + "\n"
    print(toWrite.strip())
    with open(fag, "a") as f:
            f.write(toWrite)
            f.close()
