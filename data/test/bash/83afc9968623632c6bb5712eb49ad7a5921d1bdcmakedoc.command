#!/bin/bash

( cat /Users/derek/Solutions/Public/Blue-mambo/Doxyfile ; echo "OUTPUT_DIRECTORY=/Users/derek/Documentation/BlueMambo" ) | /usr/local/bin/doxygen -

pushd /Users/derek/Documentation/BlueMambo/html
make install
popd

rm -f /Users/Derek/loadDocSet.scpt
echo "tell application \"Xcode\"" >> /Users/Derek/loadDocSet.scpt
echo "load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/uk.co.GordonKnight.BlueMambo.docset\"" >> /Users/Derek/loadDocSet.scpt
echo "end tell" >> /Users/Derek/loadDocSet.scpt

# Run the load-docset applescript command.
 
osascript /Users/Derek/loadDocSet.scpt

rm -f /Users/Derek/loadDocSet.scpt
