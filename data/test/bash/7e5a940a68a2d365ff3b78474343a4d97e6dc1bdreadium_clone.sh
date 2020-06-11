#!/bin/sh
#---------------------------------------------------
# This script is configured to clone the specified 
# Readium repo and initialize the submodules
# It sets the repo and submodule to the $BRANCH branch
# @rkwright, December 2015
#---------------------------------------------------
# make sure the supplied a version
red='\033[1;31m'
green='\033[0;32m'
NC='\033[00m' # no color

function echo_pwd {
	printf "${green}"
	pwd
	printf "${NC}"
}

function printg {
	printf "${green}"
	printf %s "$1"
	printf "${NC}\n"
}

function printr {
	printf "${red}"
	printf %s "$1"
	printf "${NC}\n"
}

function init_repo {
    printg "Cloning from branch '$BRANCH' in repo '$REPO'"
   
    git clone --recursive $1 $2
    cd $2
	echo_pwd
 	git checkout $BRANCH

    init_subrepo
}

function init_subrepo {
  
    printg "Initializing submodules to branch '$BRANCH'"

    git submodule update --init --recursive
    git submodule foreach --recursive "git checkout $BRANCH"

   printg "Completed initializing submodules to branch '$BRANCH'"
}
#-------------------------------------------------------

if [ $# -lt 2 ]
  then
    printr "No repo and/or branch tag supplied!  Exiting..."
    printr "Usage: ./readium_clone.sh <repo-name> <branch> [<repo-suffix>]"
    printr "To clone master: readium_clone.sh <repo-name> master [<repo-suffix>]"
    exit 1
fi

# save the argument - the branch name
REPO=$1
BRANCH=$2

# see if the user supplied a suffix
SUFFIX=''
if [ $# -eq  3 ]
  then
    SUFFIX=$3
    printg "Appending suffix '$SUFFIX' onto repo folder name"
fi

# save the original folder
ROOT_PWD=$(pwd)
printg "Root folder = $ROOT_PWD" 

printg "Removing any pre-existing folder named '$REPO$SUFFIX' ..."
# first get rid of the old repo, if any
rm -rf $REPO$SUFFIX

# now clone the repo
init_repo "https://github.com/readium/$REPO.git" "$REPO$SUFFIX"

printg "-------- Clone of branch '$BRANCH' into '$REPO$SUFFIX' complete -----------"
