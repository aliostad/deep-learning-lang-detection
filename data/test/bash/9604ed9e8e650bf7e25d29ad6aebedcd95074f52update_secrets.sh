#!/bin/bash
#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM and on the cluster
#
# usage:
#   ./update_secrets.sh <name of secret repo>

secret_repo=$1

if [ -d $secret_repo ]; then
    echo "=-=-=-=-=-=-=-= delete $secret_repo"
    rm -rf $secret_repo
fi
echo "=-=-=-=-=-=-=-= git clone $secret_repo"
git clone "git@git.library.nd.edu:$secret_repo"

files_to_copy="
    config/application.yml
    config/database.yml
    "

for f in $files_to_copy; do
    echo "=-=-=-=-=-=-=-= copy $f"
    if [ -f $secret_repo/cogitate/$f ];
    then
        cp $secret_repo/cogitate/$f $f
    else
        echo "Fatal Error: File $f does not exist in $secret_repo/cogitate"
        exit 1
    fi
done
