#!/bin/bash

# ADapted from: https://gist.github.com/Pangoraw/0361c583a8d0c536b0af8bcefbc2171a

set -o errexit
set -o pipefail
set -o nounset

ZOTERO_DIR="$HOME/Zotero"
ZOTERO_DB="${ZOTERO_DIR}/zotero.sqlite"

PDF_READER="zathura"

SELECTOR="fzf"

COPIED_DB=""
if ! sqlite3 $ZOTERO_DB "select * from items;" >/dev/null 2>&1
then
    # the database is locked (5) by Zotero probably.
    COPIED_DB="$ZOTERO_DB.tmp.sqlite"
    cp $ZOTERO_DB $COPIED_DB
    ZOTERO_DB="$COPIED_DB"
fi

# Query to include author and title
SELECTED_ENTRY=$(sqlite3 $ZOTERO_DB "
SELECT itemDataValues.value AS title, 
       creators.firstName || ' ' || creators.lastName AS author
FROM items
LEFT JOIN itemData ON itemData.itemID = items.itemID
LEFT JOIN itemDataValues ON itemData.valueID = itemDataValues.valueID
LEFT JOIN itemCreators ON itemCreators.itemID = items.itemID
LEFT JOIN creators ON creators.creatorID = itemCreators.creatorID
LEFT JOIN itemAttachments ON itemAttachments.parentItemID = items.itemID
LEFT JOIN items attachmentItems ON attachmentItems.itemID = itemAttachments.itemID
WHERE itemData.fieldID = 1
    AND itemAttachments.path LIKE 'storage:%'
    AND itemAttachments.contentType = 'application/pdf'
GROUP BY items.itemID;
" 2>/dev/null | sed 's/|/ - /g' | $SELECTOR)

# Exit if no selection was made
if [[ -z "$SELECTED_ENTRY" ]]; then
    echo "No selection made. Exiting."
    exit 1
fi

# Extract the title from the selected entry
SELECTED_TITLE=$(echo "$SELECTED_ENTRY" | awk -F ' - ' '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//')

# Query to get the path of the selected PDF
SELECTED_PATH=$(sqlite3 $ZOTERO_DB "
SELECT attachmentItems.key || '/' || itemAttachments.path
FROM items
LEFT JOIN itemData ON itemData.itemID = items.itemID
LEFT JOIN itemDataValues ON itemData.valueID = itemDataValues.valueID
LEFT JOIN itemAttachments ON itemAttachments.parentItemID = items.itemID
LEFT JOIN items attachmentItems ON attachmentItems.itemID = itemAttachments.itemID
WHERE itemData.fieldID = 1
    AND itemDataValues.value = '${SELECTED_TITLE}'
    AND itemAttachments.path LIKE 'storage:%'
    AND itemAttachments.contentType = 'application/pdf';
" 2>/dev/null | tail --lines=1)

# Exit if no path was found
if [[ -z "$SELECTED_PATH" ]]; then
    echo "No PDF path found for the selected title. Exiting."
    exit 1
fi

# Construct the full path to the PDF
SELECTED_PATH="${ZOTERO_DIR}/storage/${SELECTED_PATH/storage:/\/}"


# Clean up the temporary database copy if it was created
if [[ -n "$COPIED_DB" ]]; then
    rm "$COPIED_DB"
fi

nohup $PDF_READER "$SELECTED_PATH" >/dev/null 2>&1 &
