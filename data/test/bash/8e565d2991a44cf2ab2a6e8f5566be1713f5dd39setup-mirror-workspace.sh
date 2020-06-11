#!/bin/sh
# setup-mirror-workspace.sh <base-remote> <destination-remote>

set -e

usage () {
  echo "Usage: setup-mirror-workspace.sh <base-remote> <destination-remote>"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

BASE_REPO="$1"
DEST_REPO="$2"

echo "BASE_REPO: $BASE_REPO"
echo "DEST_REPO: $DEST_REPO"

DEST_DIR="workspace-$(echo $DEST_REPO | grep -o -e "[^/][^/]*$")"
echo "DEST_DIR: $DEST_DIR"

echo ""
if [ ! -d $DEST_DIR ]; then
  echo "Cloning BASE_REPO $BASE_REPO"
  git clone $BASE_REPO $DEST_DIR
else
  echo "Skipping BASE_REPO clone (directory $DEST_DIR already exists)"
fi

echo ""
echo "Adding DEST_REPO remote $DEST_REPO"
(
  set -e
  cd $DEST_DIR
  git remote remove dest >/dev/null 2>&1 || true
  git remote add dest $DEST_REPO

  echo ""
  echo "See git remotes now:"
  git remote -v

  echo ""
  echo "Sanity git fetch dest remote:"
  git fetch dest -p || {
    echo "fetch: FAILED"
    exit 1
  }
  echo "fetch: OK"
)
