#!/bin/sh

PUBLIC_REPO=pandora_ros_pkgs
REPO_DIR=upstream
REPO_NAME="$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')"  
AUTHOR_NAME="$(git show -s --format=%an)" 
AUTHOR_EMAIL="$(git show -s --format=%ae)"
AUTHOR_ID="$AUTHOR_NAME <$AUTHOR_EMAIL>"
COMMIT_MESSAGE="$(git show -s --format=%B HEAD)"

echo '\033[1;31m'Importing repo $REPO_NAME to $PUBLIC_REPO'\033[0m'

mkdir $REPO_DIR
find . -maxdepth 1 -mindepth 1 -not -name ci-scripts -not -name $REPO_DIR -exec mv '{}' $REPO_DIR \;

git clone git@github.com:pandora-auth-ros-pkg/$PUBLIC_REPO.git
cd $PUBLIC_REPO

rm -rf $REPO_NAME
mkdir $REPO_NAME
find $WORKSPACE/$REPO_DIR -maxdepth 1 -mindepth 1 -not -name .git -exec cp -r '{}' $REPO_NAME \;

git add -A
git diff-index --quiet HEAD || git commit --author="$AUTHOR_ID" -m "$COMMIT_MESSAGE"
git push origin hydro-devel

# Update repos.yml
pandoradep update $WORKSPACE/$REPO_DIR $REPO_NAME $JENKINS_SCRIPTS/pandoradep/repos.yml
