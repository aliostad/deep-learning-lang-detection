#! /bin/bash
#
# get_repo_location.sh [repo_name]
# For a given requested repo (e.g. "/nand/myproject.git" if using 
# "git clone git@xxx.com/nand/myproject.git"),
# return the location in the local filesystem where this repo is stored, e.g. 
# "/nfs/git_repos/nand/myproject/"
# FORK THIS GIT REPOSITORY AND EDIT THIS FILE
#

RESULT=
REPO_ROOT="$(pwd)/repos/"

# Remove front "/"
REPO="$1"
REPO=${REPO:1}

# Remove ".git"
if [ ${REPO:${#REPO} - 4} == ".git" ]; then
  REPO=${REPO:0:${#REPO} - 4}

  # Allow only xxx/xxx projects.
  if [ "$(grep -o "/" <<<"$REPO" | wc -l)" == "1" ]; then
    RESULT=$REPO_ROOT$REPO

    # Init the git repo if it wasn't initialized previously
    if [ ! -f "$RESULT/HEAD" ]; then
      (mkdir -p $RESULT && cd $RESULT && git init --bare) > /dev/null
    fi
  fi
fi

if [ ! -z "$RESULT" ]; then
  echo -n $RESULT
fi