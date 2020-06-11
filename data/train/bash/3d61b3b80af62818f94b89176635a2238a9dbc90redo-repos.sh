#!/usr/bin/env bash
#
# Copyright (c) 2012 Robinson Tryon <qubit@runcibility.com>
# License: GPLv3+
#
# Tear down/re-create repositories for testing bibisect integration
# with tinbuild2 buildbot system.

echo "Blowing away old repos and re-creating new ones"

BASE=~/src/libreoffice/
#LOCAL_REPO="tb_${PROFILE_NAME}_${B}_bibisect"
#LOCAL_REPO="tb_test_master_bibisect"
LOCAL_REPO="bibisect-repository"
REMOTE_REPO="fake-remote"

cd $BASE
# Delete existing repos.
rm -rf $LOCAL_REPO
rm -rf $REMOTE_REPO

# Make the remote.
mkdir $REMOTE_REPO
cd $REMOTE_REPO
git init --bare

# Make the local repo.
cd $BASE
# NOTE: When deployed the remote will be specific to
# - The buildbot
# - The minor version # of LO (so 3.5 and 3.6 have different repos)
git clone "file://localhost${BASE}${REMOTE_REPO}" $LOCAL_REPO

# Set up the repo
cd $LOCAL_REPO
touch .gitignore
git add .gitignore
git commit -m "Initialize repository"
git push origin master

echo "Done with the repo work"