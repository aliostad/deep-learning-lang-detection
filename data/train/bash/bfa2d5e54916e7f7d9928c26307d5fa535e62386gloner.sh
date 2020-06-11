#!/bin/sh

# Author:  Gabriel Jacinto aka. GabrielJMJ <gamjj74@hotmail.com>
# License: MIT

# Creates path if it does not exists
function createPath () {
    if [ ! -d "$1" ]; then
        mkdir $1;
    fi
}

# Returns the path to clone
function createPathForRepo () {
    IFS='/' read -ra REPO_PARTS <<< "$1";

    for ((i=0; i < "${#REPO_PARTS[@]}"; i++)); do
        if [ $i == 1 ]; then
            rm -rf ${REPO_PARTS[$i]};
        else 
            createPath ${REPO_PARTS[$i]};
            cd ${REPO_PARTS[$i]};
        fi
    done
}

# Returns the Repo name 
# <user>/<repo>
function getRepoName () {
    IFS=':' read -ra REPO_PARTS <<< "$1";
    return REPO_PARTS[0];
}

while getopts f: ARG; do
  case "$ARG" in
    f) REPOSITORIES_FILE=$OPTARG;
  esac
done

if [ -n "$REPOSITORIES_FILE" ]; then
    REPOS_FILE=`cat $REPOSITORIES_FILE`;

    IFS=';' read -ra REPOSITORIES <<< "$REPOS_FILE";

    for REPO in "${REPOSITORIES[@]}"; do
        IFS=':' read -ra REPO_PARTS <<< "$REPO";
        BRANCH="${REPO_PARTS[1]}";
        REPOSITORY="${REPO_PARTS[0]}";
        createPathForRepo $REPOSITORY;

        git clone -b $BRANCH "http://github.com/"$REPOSITORY;
        cd ../;
    done
fi

echo 'DONE!';