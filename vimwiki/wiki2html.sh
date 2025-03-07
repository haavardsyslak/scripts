#!/bin/bash
#     __ 
# |_|(_ 
# | |__)
#
# This is heavily based on this code here:
# https://gist.github.com/maikeldotuk/54a91c21ed9623705fdce7bab2989742
# Which is heavily based on this code here:
#$\frac{\frac{x}{1}}{x - y}$ https://gist.github.com/enpassant/0496e3db19e32e110edca03647c36541
# Special thank you to the user enpassant for starting it https://github.com/enpassant

# ARGUMENT PARSING
# Do not overwrite (0) or overwrite (1)
OVERWRITE="$1"
# Syntax chosen for the wiki
SYNTAX="$2"
# File extension for the wiki
EXTENSION="$3"
# Full path of the output directory
OUTPUTDIR="$4"
# Full path of the wiki page
INPUT="$5"
# Full path of the css file for this wiki
CSSFILENAME=$(basename "$6")
# Full path to the wiki's template
TEMPLATE_PATH="$7"
# The default template name
TEMPLATE_DEFAULT="$8"
# The extension of template files
TEMPLATE_EXT="$9"
# Count of '../' for pages buried in subdirs
ROOT_PATH="${10}"
# If file is in vimwiki base dir, the root path is '-'
[[ "$ROOT_PATH" = "-" ]] && ROOT_PATH=''

# Example: index.md
FILE=$(basename "$INPUT")
# Example: index
FILENAME=$(basename "$INPUT" ."$EXTENSION")
# Example: /home/rattletat/wiki/text/uni/
FILEPATH=${INPUT%$FILE}
# Example: /home/rattletat/wiki/html/uni/index
OUTPUT=$OUTPUTDIR$FILENAME

# PANDOC ARGUMENTS

MATHJAX="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
# If you have Mathjax locally use this:
#MATHJAX="/usr/share/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

# PREPANDOC PROCESSING AND PANDOC

pandoc_template="pandoc \
    --mathjax=$MATHJAX \
    --template=$TEMPLATE_PATH$TEMPLATE_DEFAULT$TEMPLATE_EXT \
    -f $SYNTAX \
    -t html \
    -c $CSSFILENAME \
    -M root_path:$ROOT_PATH
	--metadata title=$FILENAME"
# Searches for markdown links (without extension or .md) and appends a .html
#regex1='s/[^!()[]]*(\[[^]]+\])\(([^.)]+)(\.md)?\)/\1(\2.html)/g'
regex1='s/[^!()[]]*(\[[^]]+\])\(([^.)]+)(\.md)?\)/ \1(\2.html)/g'
# [^!\[\])(]*(\[[^\]]+\])\(([^).]+)(\.md)?\)
# Removes placeholder title from vimwiki markdown file. Not needed if you use a
# correct YAML header.
# regex2='s/^%title (.+)$/---\ntitle: \1\n---/'

pandoc_input=$(cat "$INPUT" | sed -r "$regex1")
pandoc_output=$(echo "$pandoc_input" | $pandoc_template)

# POSTPANDOC PROCESSING

# Removes "file" from ![pic of sharks](file:../sharks.jpg)
regex3='s/file://g'

echo "$pandoc_output" | sed -r $regex3 > "$OUTPUT.html"

# With this you can have ![pic of sharks](file:../sharks.jpg) in your markdown file and it removes "file"
# and the unnecesary dot html that the previous command added to the image.
# sed 's/file://g' < /tmp/crap.html | sed 's/\(png\|jpg\|pdf\).html/\1/g' | sed -e 's/\(href=".*\)\.html/\1/g' > "$OUTPUT.html"

# Send to ssh
#echo $OUTPUT.html
# TODO only send compiled files, instead of entire folder
scp -r ~/uisfiles/notes/html/* syslak@prv.cymru:http
