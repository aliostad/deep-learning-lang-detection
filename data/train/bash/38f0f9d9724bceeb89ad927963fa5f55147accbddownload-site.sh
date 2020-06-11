#!/bin/bash
## download-site.sh
# Use wget to recursively download everything publicly accessible in a
# site, saving the files to user-set location.

save_location="$(get-config "download-site/save-location" \
                            -what-do "where to save the site\'s files")" || exit 1

if [ "$#" != "1" ]; then
    echo "Usage: $(basename "$0") domain.tld"
    echo "This downloads the site at domain.tld and puts it in $save_location."
    exit 1
else
    cd "$save_location"
    wget --continue --mirror --wait=0.2 "$1"
fi
