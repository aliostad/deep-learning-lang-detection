#!/bin/bash

BRANCH=$1

if [ $# -eq 0 ]
    then
        echo "Missing branchName. You can't continue."
        exit 1
fi

LOCAL_REPOS=`find \`pwd\` -name ".git"|rev|cut -d "/" -f 2-|rev`
# echo $LOCAL_REPOS

REPO_ROOT=`pwd`

for REPO in ${LOCAL_REPOS} ;do
    cd ${REPO}
    echo "$REPO"
    if [ `find . -maxdepth 1 -name ".ignore"` ]; then
        echo -e "Ignoring $REPO\n"
    else
        pullCommand=`git pull origin $BRANCH`
        echo -e "==>$pullCommand"
    fi
    echo "--------"
    cd ${REPO_ROOT}
done
cd ${REPO_ROOT}