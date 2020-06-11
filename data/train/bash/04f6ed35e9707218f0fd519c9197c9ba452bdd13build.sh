#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BUILDDIR=$DIR
cd $BUILDDIR

if [[ $1 == '0.95' ]]
then
  echo "Building Pitivi 0.95"
  PITIVI=pitivi-0.95
  BRANCHNAME=0.95
  if [[ $2 == '' ]]
  then
    REPO=$BUILDDIR/xdg-app-repos/pitivi/
  else
    REPO=$2
  fi
else
  echo "Building Pitivi master"
  PITIVI=pitivi
  BRANCHNAME=master

  if [[ $1 == '' ]]
  then
    REPO=$BUILDDIR/xdg-app-repos/pitivi/
  else
    REPO=$1
  fi
fi

JSON=$DIR/$PITIVI.json
APPDIR=$BUILDDIR/$PITIVI/

mkdir -p $REPO

xdg-app-builder --disable-cache $APPDIR $JSON || exit 1

echo "Exporting repo $REPO"
xdg-app build-export $REPO $APPDIR $BRANCHNAME || exit 1
echo "Exporting repo $REPO"
xdg-app repo-update $REPO || exit 1
echo "DONE!"
