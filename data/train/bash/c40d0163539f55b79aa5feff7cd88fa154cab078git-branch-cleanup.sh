#!/bin/bash
###############################################################################
# "Clean up" a branch that was already merged to master
# Author: Markus Dangl <markus@q1cc.net>
###############################################################################
# Creates a tag for the branch, pushes it to origin,
# then deletes the branch both remotely and locally.
# !!! Please make sure that your branch is fully merged, this script
# will not check that before deletion !!!
set -e
#set -x

invoke() {
    echo "$@"
    "$@"
}

usage() {
    echo "Usage:"
    echo "    $0 <branch>"
}

[ -n "$1" ] || {
    usage 1>&2
    exit 1
}

invoke git checkout $1
invoke git pull
invoke git tag -a branch_$1 -m "Already merged $1 to master"
invoke git push --tags
echo ""
invoke git checkout master
echo ""
invoke git branch -d $1
invoke git push origin --delete $1

