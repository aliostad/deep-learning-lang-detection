#!/usr/bin/env bash

set -e
set -x

export REPO=urbanetic/aurin-esp
if [ "$TRAVIS_BRANCH" != "" ]; then
    BRANCH=$TRAVIS_BRANCH
else
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
fi
BRANCH=$(echo $BRANCH | sed 's#/#_#g' | tr '[:upper:]' '[:lower:]')

cd app
echo "Building Docker image $REPO:$BRANCH from $(pwd)"
docker build -t $REPO:$BRANCH .
cd -

if [ "$BRANCH" == "master" ]; then
    echo "Re-tagging build of master branch:"
    VERSION=$(node -p -e "require('./package.json').version")
    docker tag $REPO:$BRANCH $REPO:$VERSION
    docker tag $REPO:$BRANCH $REPO:latest
    echo "Tagged image as $REPO:$VERSION and $REPO:latest"
fi
