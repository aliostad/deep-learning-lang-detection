#!/bin/bash

set -e
set -o pipefail

export LC_ALL=C

confirm() {
    read -p "$1 (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

save_base_path="$(cygpath "$APPDATA")/Factorio/saves"

save_game_name="${1:-git}"
archive="$save_base_path/$save_game_name.zip"

if [ -e "$archive" ]; then
    if ! confirm "File '$(cygpath -w "$archive")' already exists. Overwrite?"; then
        exit 1
    fi
fi

echo "Creating archive '$(cygpath -w "$archive")'..."
git archive --format=zip --prefix="$save_game_name"/ -1 -o "$archive" HEAD
