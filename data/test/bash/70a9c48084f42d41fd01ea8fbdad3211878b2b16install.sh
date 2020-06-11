#!/bin/bash
set -e

REPO_URL="https://github.com/VPH-Share/taverna-server"
REPO_URL=${REPO_URL%/}                    # Remove trailing slash, if any
REPO_NAME=${REPO_URL##*/}
REPO_USER=${REPO_URL%/*}

if [ "$EUID" -ne "0" ] ; then
  echo "Script must be run as root." >&2
  exit 1
fi

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v $1 &>/dev/null
  then
    return 0
  else
    return 1
  fi
}

# Basic dependencies
requires() {
  echo "Script must be run as root."
  echo "Script requires:"
  echo " - wget and unzip; or"
  echo " - git"
  echo " "
  echo "Please file a bug report at $REPO_URL/issues"
  echo "Please detail your operating system type, version and any other relevant details"
  exit 1
}

if [ -d /var/lib/tomcat6/webapps/taverna-server ]
then
  echo "You already have $REPO_NAME installed. You'll need to remove $REPO_NAME if you want to install"
  exit
fi

# Get Repository
if exists git; then
  git clone $REPO_URL $REPO_NAME
  LOCAL_REPO=$REPO_NAME
elif $(exists wget) && $(exists unzip); then
  wget -Nq $REPO_URL/archive/master.zip
  unzip -o master.zip
  LOCAL_REPO="$REPO_NAME-master"
else
  requires
fi

cd $LOCAL_REPO
./provision.sh 2>&1 | tee ~/$REPO_NAME-install.log
