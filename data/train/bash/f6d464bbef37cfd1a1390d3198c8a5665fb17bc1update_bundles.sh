#!/usr/bin/env bash
# For each git repo defined in the *.list files,
# this script creates a cloned git repo if the repo does not exist
# or updates the repo and checks out the branch defined in the current
# *.lst file

pushd .
_THIS_SCRIPT_DIR="$(cd `dirname \`which $0\``; pwd)"
cd $_THIS_SCRIPT_DIR

###################################################################################
# Function: _updateRepo(bundledir,repo_name, repo_branch,repo_url)
# - function to
###################################################################################
_updateRepo() {
  _BUNDLE_DIR=$1
  _REPO_NAME=$2
  _REPO_BRANCH=$3
  _REPO_URL=$4
  _REPO_DIR="$_BUNDLE_DIR"/"$_REPO_NAME"
  echo
  if [[ -e "$_REPO_DIR" ]]; then
    echo \"$_REPO_NAME\" already exists. Checking for updates...
    cd "$_REPO_DIR"
    git checkout "$_REPO_BRANCH"
    git pull
    git submodule update --init --recursive
  else
    echo \"$_REPO_NAME\" does not exist. Cloning $_REPO_URL
    git clone --recursive "$_REPO_URL" "$_REPO_DIR"
    cd "$_REPO_DIR"
    git checkout "$_REPO_BRANCH"
  fi
}

###################################################################################
# Function: _updateBundle(bundleListFile)
# - function to parse bundle list file and call updateRepo for each repo in list
###################################################################################
_updateBundle() {
  _BUNDLE_LIST_FILE=$1
  _BUNDLE_LIST_NAME=${_BUNDLE_LIST_FILE%.list} #Strip .list from end of string
  _BUNDLE_DIR="$_THIS_SCRIPT_DIR/$_BUNDLE_LIST_NAME"

  echo Updating repos defined in \"$_BUNDLE_LIST_FILE\"
  mkdir -p "$_BUNDLE_DIR"
  if [[ -e "$_BUNDLE_DIR" ]]; then
    #Parse repos in bundle list file
    #  First delete lines that are comments (starts with ; or whitespace then ;)
    #  Next, remove comments at end of lines
    #  Finally read each line (after stripping comments)
    sed  -e '/^\s*;.*$/d' -e 's/;.*$//' "$_THIS_SCRIPT_DIR"/"$_BUNDLE_LIST_FILE" | \
      while read line; do
        _updateRepo "$_BUNDLE_DIR" $line
      done
      echo
      echo Finished updating bundles defined in \"$_BUNDLE_LIST_FILE\"
    else
      echo ERROR: Could not create folder \"$_BUNDLE_DIR\"
    fi
  }

  for bundlelistfile in *.list ; do
    _updateBundle "$bundlelistfile"
  done
  popd > /dev/null

