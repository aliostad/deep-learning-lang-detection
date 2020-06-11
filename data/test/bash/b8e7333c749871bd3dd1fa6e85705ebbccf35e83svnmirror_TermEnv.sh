#!/bin/bash

SVN_SOURCE_REPO_URI_ROOT=svn+ssh2002://svn.astrics.net/home/vanity/.svnroot/DevEnv
SVN_MIRROR_REPO_PATH_ROOT=$HOME/.svnmirror/TermEnv
SVN_MIRROR_REPO_URI_ROOT=file://$SVN_MIRROR_REPO_PATH_ROOT
TARGETS=( AstricsTermEnv )

for TARGET in "${TARGETS[@]}"; do

	SVN_SOURCE_REPO_URI=$SVN_SOURCE_REPO_URI_ROOT/$TARGET
	SVN_MIRROR_REPO_PATH=$SVN_MIRROR_REPO_PATH_ROOT/$TARGET
	SVN_MIRROR_REPO_URI=$SVN_MIRROR_REPO_URI_ROOT/$TARGET

	if [ ! -d $SVN_MIRROR_REPO_PATH_ROOT ]; then
		mkdir -p $SVN_MIRROR_REPO_PATH_ROOT
	fi

	if [ ! -d $SVN_MIRROR_REPO_PATH ]; then
		echo "# svnadmin create $SVN_MIRROR_REPO_PATH"
		svnadmin create $SVN_MIRROR_REPO_PATH

		echo -e '#!/bin/sh\n\n' > $SVN_MIRROR_REPO_PATH/hooks/pre-revprop-change
		chmod 755 $SVN_MIRROR_REPO_PATH/hooks/pre-revprop-change

		echo "# svnsync init $SVN_MIRROR_REPO_URI $SVN_SOURCE_REPO_URI"
		svnsync init $SVN_MIRROR_REPO_URI $SVN_SOURCE_REPO_URI
	fi

	echo "# svnsync sync $SVN_MIRROR_REPO_URI"
	svnsync sync $SVN_MIRROR_REPO_URI
	if [ $? -eq 0 ]; then
		echo $SYNC_RESULT
		svn export --quiet --force $SVN_MIRROR_REPO_URI/$TARGET/vanity $HOME/Dropbox/Private/TermEnv
	fi

done

