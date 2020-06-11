#!/bin/bash

################################################################################
# Script that takes a list of repository names and an owner ID and pushes them
# to Github.
################################################################################

if [[ -z $1 || -z $2 ]]; then
  echo "Usage: push_up.sh <file_of_repos> <owner>"
  exit
fi

repo_file=${1}
owner=${2}

scm="git@github.com:${owner}"

repos=$(cat ${repo_file})
for repo in $repos
do
  echo "Uploading ${repo}"
  cd ${repo}.git
  git push --mirror ${scm}/${repo}.git
  cd ../
done
