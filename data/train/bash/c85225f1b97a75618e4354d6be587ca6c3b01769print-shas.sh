#!/bin/bash
#=======================================================================================
#
# Prints shas for all repos in the working directory.
#
# Author: Chris Malley (PixelZoom, Inc.)
#
#=======================================================================================

CHIPPER_BIN=`dirname "${BASH_SOURCE[0]}"`
WORKING_DIR=${CHIPPER_BIN}/../..
cd ${WORKING_DIR}

for repo in `ls -1`
do
    # if it's a Git repository...
    if [ -d $repo/.git ]
    then
        cd $repo > /dev/null
        echo -n $repo ": "
        git rev-parse HEAD
        cd ..
    else
        echo ">>>>>>>>>>>>>>>>>>>>>>>> Missing repo: $sim"
    fi
done