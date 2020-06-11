#!/bin/bash

FOLDER_SOURCE=/jekyll-hook/ailabitmo/ailabitmo.github.io/master/code
FOLDER_BUILD=/jekyll-hook/ailabitmo/ailabitmo.github.io/master/site
REPO_NAME=ailabitmo.github.io
REPO_BRANCH=master
REPO_OWNER=ailabitmo
REPO_URL=https://github.com/ailabitmo/ailabitmo.github.io.git

./scripts/build.sh $REPO_NAME $REPO_BRANCH $REPO_OWNER $REPO_URL $FOLDER_SOURCE $FOLDER_BUILD

./scripts/publish.sh $REPO_NAME $REPO_BRANCH $REPO_OWNER $REPO_URL $FOLDER_SOURCE $FOLDER_BUILD

service nginx restart

./jekyll-hook.js
