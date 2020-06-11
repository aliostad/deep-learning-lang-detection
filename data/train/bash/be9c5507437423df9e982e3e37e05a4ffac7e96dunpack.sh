#!/bin/bash

. ./config.sh

./check_prereqs.sh

if [ $? -ne 0 ]
then
    exit 1
fi

rm -rf $SOURCE_DIR || exit 1
mkdir $SOURCE_DIR || exit 1
cd $SOURCE_DIR

for archive in `cat $BASE_DIR/archives.list`
do
    extension=`echo "$archive" | awk -F . '{print $NF}'`

    echo "Unpacking $archive"

    if [ "$extension" = 'zip' ]
    then
        unzip -q $ARCHIVE_DIR/$archive || exit 1
    else
        tar xf $ARCHIVE_DIR/$archive || exit 1
    fi

    # CG: [XXX] Hack :/
    if [ "$archive" = 'mingw-w64-i686-gobject-introspection-1.44.0-3-any.pkg.tar.xz' ]
    then
        mv 'mingw32' 'gobject-introspection-1.44.0-3-any'
    fi
done

for hg_repo in `cat $BASE_DIR/hg_repos.list`
do
    repo_name=`basename $hg_repo`

    echo "Unpacking $repo_name (cloning from Mercurial repository)"

    hg clone $hg_repo $repo_name
done

for git_repo in `cat $BASE_DIR/git_repos.list`
do
    repo_name=`basename $git_repo`

    echo "Unpacking $repo_name (cloning from Git repository)"

    git clone $git_repo $repo_name
done

