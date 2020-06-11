#!/bin/bash
#-------------------------------------------------------------------------------
# Author: Lukasz Janyst <ljanyst@cern.ch>
# Description: Link the RPM files from the download section, create the
#              repository, and sychronize the SLAC version
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
SLAC_CREDENTIALS=ljanyst@iris02.slac.stanford.edu
SLAC_REPO_PATH=/afs/slac.stanford.edu/www/projects/scalla/binaries/
CERN_REPO_PATH=/var/www/html-xrootd/sw/repos
CERN_DIST_PATH=/var/www/html-xrootd/sw/releases

#-------------------------------------------------------------------------------
# Parse the commandline parameters
#-------------------------------------------------------------------------------
if [ $# -ne 2 ]; then
  echo "Usage:"
  echo "   $0 version [stable|testing]"
  exit 1
fi

VERSION=$1
REPO=$2

echo "[i] Adding version $VERSION to the $REPO repo..."

#-------------------------------------------------------------------------------
# Check if the repo and the requested version exist
#-------------------------------------------------------------------------------
if [ ! -e $CERN_DIST_PATH/$VERSION/rpms/user_xrootd ]; then
  echo "[!] Version $VERSION not found"
  exit 2
fi

if [ ! -e $CERN_REPO_PATH/$REPO ]; then
  echo "[!] Repo $REPO does not exist"
  exit 3
fi

#-------------------------------------------------------------------------------
# Update the repo for all supported versions of slc
#-------------------------------------------------------------------------------
for slcver in $CERN_REPO_PATH/$REPO/slc/*; do
  slcver="`basename $slcver`";
  (
    echo "[i] Processing SLC$slcver"
    cd $CERN_REPO_PATH/$REPO/slc/$slcver;

    #---------------------------------------------------------------------------
    # Check architectures
    #---------------------------------------------------------------------------
    for arch in `ls`; do
    (
      echo "[i]   Arch: $arch"
      cd $arch
      SRCDIR=$CERN_DIST_PATH/$VERSION/rpms/user_xrootd/slc$slcver/$arch
      if [ ! -e $SRCDIR ]; then
         echo "[!]     Distdir not found: $SRCDIR"
         continue
      fi
      for rpm in `ls $SRCDIR/*.rpm`; do
         ln -sf $rpm
         createrepo --update -q . 
      done
    )
    done
  )
done

#-------------------------------------------------------------------------------
# Sync with SLAC
#-------------------------------------------------------------------------------
rsync -rLv $CERN_REPO_PATH/$REPO/slc $SLAC_CREDENTIALS:$SLAC_REPO_PATH/$REPO
