#!/usr/bin/env bash

#
# [git] convert repo to bare
#

set -e

if [ "$1" = "" ]; then
    echo "Set directory"
    exit 1
fi

REPO=$(readlink -f "$1")

if [ ! -d "$REPO" ]; then
    echo "$REPO is not a directory"
    exit 2
fi

if [ ! -d "$REPO/.git" ]; then
    echo "$REPO already is bare"
    exit
fi

BARE_FOLDER=$(mktemp -d --tmpdir=.)

cd "$REPO"
mv .git "../$BARE_FOLDER" && rm -fr *
mv ../$BARE_FOLDER/.git/* .

rmdir "../$BARE_FOLDER/.git"
rmdir "../$BARE_FOLDER"

git config --bool core.bare true

cd ..

# renaming just for clarity
if [[ ! "$REPO" == *".git" ]]; then
    mv "$REPO" "$REPO.git"
fi