#!/bin/bash

# Change into the project's root
cd ../

# Grab the repo directory name
REPO_NAME=${PWD##*/}

# Obtain the project's remote git path
REPO_URL=`git config --get remote.origin.url`

# create a temp directory & store the freshly cloned repository
mkdir ../.repo.new

git clone $REPO_URL ../.repo.new

# Perform build specific logic...  EXAMPLE logic provided below

# Copy over wp config 
cp wp-config.php ../.repo.new/

# make the switch!
cd ../

mv $REPO_NAME .repo.old

mv .repo.new $REPO_NAME

# Go check to make sure everything is kosher, then remove the old one
rm -rf .repo.old

echo 'Thats all folks'