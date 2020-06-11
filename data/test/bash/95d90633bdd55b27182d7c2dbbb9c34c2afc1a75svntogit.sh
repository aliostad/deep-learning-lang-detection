#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 new_repo_name"
  exit
fi
repo=$1

git svn clone --stdlayout --no-metadata -A users.txt svn+ssh://magiccvs.byu.edu/svn/indoor_nav/hydro/$repo $repo-tmp

read -p "Finished import?" yn

cd $repo-tmp
git branch -r
cd ..

read -p "Only trunk?" yn

git clone $repo-tmp $repo
rm -rf $repo-tmp
cd $repo

read -p "Was there more than trunk earlier?" yn

git remote rm origin
git remote add origin magiccvs:/git/relative_nav/$repo.git
git push -u origin master

read -p "Successful?" yn

cd ../tmp
git clone magiccvs:/git/relative_nav/$repo.git
