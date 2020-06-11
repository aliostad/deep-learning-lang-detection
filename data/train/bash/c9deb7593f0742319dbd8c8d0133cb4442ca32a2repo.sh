#!/bin/bash
## Build Automation Scripts
##
## Copywrite 2014 - Donald Hoskins <grommish@gmail.com>
## on behalf of Team Octos et al.
##
## This script automates device tree switching in the local_manifests
## directory.
##
## Usage: jet/repo.sh <branch>
## jet/repo.sh sam, jet/repo.sh nex, etc
##
##
CWD=$(pwd)
DEVICE_TREE=$1
MANI_REPO="vendor/common/prebuilt/manifests"
VENDOR_REPO="vendor/common"

cd $VENDOR_REPO
echo "Updating Repo"
git fetch sp
git pull sp kk-4.4
echo "Done Updating"
cd $CWD

if [[ $DEVICE_TREE = "" ]]
  then
  max_columns=4
  icount=0
  echo "Pick a device tree from the following sources:"
  echo "Use 'base' as a repo name to just sync the AOSP/CM required Repos"
  echo "/******************************************************************************"
  for entry in "$MANI_REPO"/*
  do
    repname=$(basename $entry)
    if [[ $repname = "cm.xml" || $repname = "aosp-s4.xml" || $repname = "README" ]]
    then
      continue
    fi

    if [[ icount -eq 0 ]]
    then
       printf "/\t${repname%.xml}\t\t"
       icount=$((icount+1))
       continue
    fi
    if [[ icount -gt 0 && icount -lt $max_columns ]]
    then
       printf "${repname%.xml}\t\t"
       icount=$((icount+1))
       continue
    else
      printf "${repname%.xml}\r\n"
      icount=0
    fi
  done
  printf "\r\n"
  exit
fi

cd $CWD

if [ ! -d ".repo/local_manifests" ]; then
  mkdir -p ".repo/local_manifests"
fi
touch ".repo/local_manifests/AOSP-S4.xml"
cat "$MANI_REPO/oct.xml" > ".repo/local_manifests/AOSP-S4.xml"
cat "$MANI_REPO/cm.xml" >> ".repo/local_manifests/AOSP-S4.xml"
if [[ $DEVICE_TREE != "base" ]]
   then
    for DEVICE_TREE in "$@"
    do
      cat "$MANI_REPO/$DEVICE_TREE.xml" >> ".repo/local_manifests/AOSP-S4.xml"
    done
fi
echo "</manifest>" >> ".repo/local_manifests/AOSP-S4.xml"

repo sync
