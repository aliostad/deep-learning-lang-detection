#!/bin/bash


REPO_DIR="/var/chef-solo"
REPO_URL="http://github.com/twelvelabs/chef-repo/tarball/master"

COOKBOOKS_DIR="$REPO_DIR/cookbooks-vendor"
COOKBOOKS_URL="http://github.com/twelvelabs/osx-cookbooks/tarball/master"


echo ""
echo "unpacking <http://github.com/twelvelabs/chef-repo> into '$REPO_DIR'..."
rm -Rf $REPO_DIR
mkdir -p $REPO_DIR
curl -sL $REPO_URL | tar -xz -C $REPO_DIR -m --strip 1


echo "unpacking <http://github.com/twelvelabs/osx-cookbooks> into '$COOKBOOKS_DIR'..."
rm -Rf $COOKBOOKS_DIR
mkdir -p $COOKBOOKS_DIR
curl -sL $COOKBOOKS_URL | tar -xz -C $COOKBOOKS_DIR -m --strip 1

echo "running chef..."
echo ""

cd $REPO_DIR
rake chef

echo ""
echo "fini!"
echo ""
