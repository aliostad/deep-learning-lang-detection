#!/bin/bash
#
#V1.0 init code
#repo forall -c replaceRemoteUrl.sh

#echo REPO_PROJECT: $REPO_PROJECT
#echo REPO_PATH: $REPO_PATH
#echo REPO_REMOTE: $REPO_REMOTE
#echo REPO_LREV: $REPO_LREV
#echo REPO_RREV: $REPO_RREV
#echo REPO_I: $REPO_I

#NEW_REMOTE=ssh://10.38.32.241:29418/android/
NEW_REMOTE=ssh://shgit.marvell.com:29418/android/

echo -n $(git config --local --get remote.shgit.url)
echo -n " --> "
echo ${NEW_REMOTE}${REPO_PROJECT}
git config --local --replace-all remote.shgit.url ${NEW_REMOTE}${REPO_PROJECT}
