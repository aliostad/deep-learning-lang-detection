#!/bin/bash

BRANCH="$1"
VERSION="$2"
REMOTE="upstream"

if [ -z "$BRANCH" ]; then
  BRANCH="master"
fi

if [ -z "$VERSION" ]; then
  VERSION="1.0"
fi

DOCS_REPO=$(cd "$(dirname "$0")"; pwd)
KARMA_REPO="$DOCS_REPO/../karma"

# checkout the branch in the karma repo
#cd $KARMA_REPO
#git fetch $REMOTE
#git checkout $REMOTE/$BRANCH

# copy the docs source
#cd $DOCS_REPO
echo "Removing old docs..."
git rm -rf src/content/$VERSION
echo "Copying the docs from master repo..."
mkdir src/content/$VERSION
cp -r $KARMA_REPO/docs/* $DOCS_REPO/src/content/$VERSION/
echo "Copying the changelog..."
echo -e "editButton: false\n" > $DOCS_REPO/src/content/$VERSION/about/02-changelog.md
cat $KARMA_REPO/CHANGELOG.md >> $DOCS_REPO/src/content/$VERSION/about/02-changelog.md

# commit sync
cd $DOCS_REPO
git add src/content/$VERSION/**/*.md src/content/$VERSION/*.md
git commit -m "Sync the docs"

# build html and commit
grunt build
#git add $VERSION/**/*.html $VERSION/*.html
git add .
git commit -m "Build"

#git push origin HEAD:master
