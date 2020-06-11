#!/bin/sh
set -e

die() {
    echo "!" 1>&2
    echo "! TEST ERROR: $*" 1>&2
    echo "!" 1>&2
    exit 1
}

cd $(dirname $0)

DEVEBA_CMD=$PWD/../../deveba/deveba.py

SB_DIR=$PWD/sandbox
SERVER_REPO_GIT=$SB_DIR/server.git

CLIENT1_REPO=$SB_DIR/client1
CLIENT2_REPO=$SB_DIR/client2

rm -rf $SB_DIR
mkdir $SB_DIR
cd $SB_DIR

# Create server repo
{
    SERVER_REPO=$SB_DIR/server
    mkdir $SERVER_REPO
    touch $SERVER_REPO/foo
    touch $SERVER_REPO/bar

    cd $SERVER_REPO
    git init
    git add .
    git ci -m 'Import'
    cd ..

    git clone --bare $SERVER_REPO $SERVER_REPO_GIT
    rm -rf $SERVER_REPO
}

# Clone server repo
git clone $SERVER_REPO_GIT $CLIENT1_REPO
git clone $SERVER_REPO_GIT $CLIENT2_REPO

# Create config files
sed "s,@CLIENT_REPO@,$CLIENT1_REPO," ../config.xml.in > client1.xml
sed "s,@CLIENT_REPO@,$CLIENT2_REPO," ../config.xml.in > client2.xml

# Run without change
$DEVEBA_CMD --config client1.xml test
$DEVEBA_CMD --config client2.xml test

# Create some changes in client1, propagate them
touch $CLIENT1_REPO/new
cd $CLIENT1_REPO
git add new
git ci -m 'Add new file'
git push
cd ..

# Get them in client2
$DEVEBA_CMD --config client2.xml test $*
[ -e $CLIENT2_REPO/new ] || die "Failed to propagate changes from client1 to client2"
