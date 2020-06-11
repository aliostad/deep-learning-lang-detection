#!/bin/bash

WORKSPACE_DIR="~/workspace"

main() {
  make_workspace
  clone_each_repo
}

# List of repos to clone
repo_names() {
  echo "
    ngin
    stat_ngin
    sport_ngin_live
  "
}

# Create the workspace directory to house all the clones
make_workspace() {
  mkdir -p $WORKSPACE_DIR
}

# Iterate over repo_names and clone each
clone_each_repo() {
  for repo in $(repo_names); do
    echo Cloning $repo
    clone_repo $repo
  done
}

# GitHub URL for the given repo name
#
# repo_name - Name of the repo (not including org name)
url() {
  name=$1
  echo "git@github.com:tstmedia/$1.git"
}

# Clone, into $WORKSPACE_DIR, the given repo
#
# repo_name - Name of the repo (not including org name)
clone_repo() {
  repo=$1
  cd $WORKSPACE_DIR && git clone $(url $repo)
}

main $*
