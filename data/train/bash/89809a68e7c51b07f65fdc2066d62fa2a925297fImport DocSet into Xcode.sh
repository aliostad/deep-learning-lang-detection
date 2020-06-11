#!/bin/sh

# Import DocSet into Xcode.sh
# BMScriptTest
#
# Created by Andre Berg on 09.10.09.
# Copyright 2009 Berg Media. All rights reserved.

#  make will invoke docsetutil. Take a look at the Makefile to see how this is done.

make -C "$DOCROOT/$DOCSET_NAME/html" install

#  Construct a temporary applescript file to tell Xcode to load a docset.
#rm -f "$TEMP_DIR/loadDocSet.scpt"
# echo "tell application \"Xcode\"" >> "$TEMP_DIR/loadDocSet.scpt"
# echo "	load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/\"" >> "$TEMP_DIR/loadDocSet.scpt"
# echo "end tell" >> "$TEMP_DIR/loadDocSet.scpt"
# TMPSCRIPT=`echo -e "tell application \"Xcode\" to load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/\""`
# arch -i386 osascript -e "${TMPSCRIPT}"

arch -i386 osascript << APPLESCRIPT
tell application "Xcode"
    load documentation set with path "/Users/$USER/Library/Developer/Shared/Documentation/DocSets/" -- (re)load all DocSets present in folder
end tell
APPLESCRIPT