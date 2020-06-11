#!/bin/sh
# Internet2 Kernel Repository Mirror Script
# 
# Copyright (c) 2010-2011 Internet2
#
# You should have received a copy of the Internet2 Intellectual Property
# Framework along with this software.  If not, see 
# <http://www.internet2.edu/membership/ip.html>
#
# ------------------------------------------------------------------------------

REPOSITORY=https://cvs3.internet2.edu/svn/web100_kernel/

#ARCHITECTURES=(i386 x86_64 ppc)
ARCHITECTURES=(i386)

DEST_REPO_DIR=/opt/perfsonar_ps/Internet2-Mirror/software.internet2.edu/web100_kernel
mkdir -p $DEST_REPO_DIR

STABLE_SVN_DIR=trunk
BRANCHES_SVN_DIR=branches
TAGS_SVN_DIR=tags

STABLE_REPO_DIR=
BRANCHES_REPO_DIR=branches
TAGS_REPO_DIR=tags

TEMP_SVN_DIR=/opt/perfsonar_ps/Internet2-Mirror/software_svn_cache
TEMP_REPO_DIR=/opt/perfsonar_ps/Internet2-Mirror/software_repo_temp
mkdir -p $TEMP_SVN_DIR
mkdir -p $TEMP_REPO_DIR

function build_repo {
	SVN_DIRECTORY=$1
	REPO_DIRECTORY=$2

	mkdir -p `dirname $TEMP_REPO_DIR/$REPO_DIRECTORY`
        rm -rf $TEMP_REPO_DIR/$REPO_DIRECTORY

        if [ ! -d $TEMP_SVN_DIR/$SVN_DIRECTORY ]; then
		return
	fi

	svn export $TEMP_SVN_DIR/$SVN_DIRECTORY $TEMP_REPO_DIR/$REPO_DIRECTORY
	if [ -d $TEMP_REPO_DIR/$REPO_DIRECTORY/rpms ]; then
		RPMS_DIR=$TEMP_REPO_DIR/$REPO_DIRECTORY/rpms
		pushd $RPMS_DIR
		for i in "${ARCHITECTURES[@]}"; do
			if [ -d $i ]; then 
				pushd $i/main
				if [ $? == 0 ]; then
					createrepo -p . 
					popd
				fi

				genbasedir $RPMS_DIR/$i
			fi
		done
		popd
	fi
}

mkdir -p $TEMP_SVN_DIR
if [ $? != 0 ]; then
	echo "Couldn't make $TEMP_SVN_DIR"
	exit -1
fi

if [ -d $TEMP_REPO_DIR ]; then
	rm -rf $TEMP_REPO_DIR
fi

mkdir -p $TEMP_REPO_DIR
if [ $? != 0 ]; then
	echo "Couldn't make $TEMP_REPO_DIR"
	exit -1
fi

mkdir -p $DEST_REPO_DIR
if [ $? != 0 ]; then
	echo "Couldn't make $DEST_REPO_DIR"
	exit -1
fi

svn co $REPOSITORY $TEMP_SVN_DIR
if [ $? != 0 ]; then
	echo "Couldn't checkout $REPOSITORY"
	exit -1
fi

pushd $TEMP_SVN_DIR

if [ -d $TESTING_SVN_DIR ]; then
	build_repo "$TESTING_SVN_DIR" "$TESTING_REPO_DIR" 
fi

if [ -d $STABLE_SVN_DIR ]; then
	build_repo "$STABLE_SVN_DIR" "$STABLE_REPO_DIR" 
fi

if [ -d $TAGS_SVN_DIR ]; then
	for i in $TAGS_SVN_DIR/*; do
		build_repo "$i" "$i" 
	done
fi

if [ -d $BRANCHES_SVN_DIR ]; then
	for i in $BRANCHES_SVN_DIR/*; do
		DIR=`basename $i`
		build_repo "$i" "$BRANCHES_REPO_DIR/$DIR" 
	done
fi

# Note: the trailing / here is needed to ensure that $TEMP_REPO_DIR doesn't get
# copied as a subdirect of $DEST_REPO_DIR
for i in $TEMP_REPO_DIR/*; do
    rsync -av --delete --exclude=.svn $i $DEST_REPO_DIR
done
