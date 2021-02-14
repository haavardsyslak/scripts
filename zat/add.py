#!/usr/bin/python3

import os
import sys


path = os.getcwd()
zatPath = os.environ["HOME"] + "/programering/scripts/zat/"

usage = """Usage:    
        add [fag] [filename]"""

args = sys.argv[1:]
if len(args) > 2:
    print("Too many argumets!")
    sys.exit(1)

elif len(args) <= 1:
    print("Not enough argumets provided!") 
    print(usage)
    sys.exit(1)

fag = zatPath + args.pop(0).lower()
fil = path + "/" + args.pop(0)

if not os.path.isfile(fil):
    print(fil, " does not exist")
    sys.exit(1)
try:
    with open(fag, "a") as f:
        f.write(fil)

except FileNotFoundError:
    ans = input("Make fag: " + fag + " [y/N]")

    if ans[0].lower() == "y":
        with open(fag, "w") as f:
            f.write(fil)

