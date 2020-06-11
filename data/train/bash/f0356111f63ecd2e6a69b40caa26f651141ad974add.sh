#!/bin/sh

EXE=`basename $0`

usage() {
  echo "Usage: $EXE dir"
  exit 0;
}

[ -z "$1" ] && usage

DIR=$1
REPO=`basename $DIR`

# sanity?!?

echo "adding REPO($REPO) in DIR($DIR)"

[ ! -d $DIR/.git ] && {
  echo "DIR: $DIR not a git repo"
  usage
}

#echo "^$REPO$"
git remote | grep -q "^$REPO$"

[ $? = 0 ] && {
  echo "REMOTE: $REPO already exists";
#  exit 1;
} || git remote add $REPO $DIR

git fetch $REPO

git branch | grep -q "$REPO$"

[ $? = 0 ] && {
  echo "BRANCH: $REPO already exits";
#  exit 1;
} || git branch --track $REPO remotes/$REPO/master

git branch -a -v

