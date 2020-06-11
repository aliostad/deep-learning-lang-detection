#!/bin/bash

HOSTNAME=$( uname -n )
case "$HOSTNAME" in
	xion.local		)	SVN_SOURCE_REPO_URI_ROOT=http://svn.neowizbugs.com/WPJ/trunk ;;
	mgr.astrics.net	)	SVN_SOURCE_REPO_URI_ROOT=http://localhost:17080/WPJ/trunk ;;
	*				)	SVN_SOURCE_REPO_URI_ROOT=svn+ssh2002://svn.astrics.net/home/vanity/.svnmirror/NeowizLab ;;
esac
SVN_MIRROR_REPO_PATH_ROOT=$HOME/.svnmirror/NeowizLab
SVN_MIRROR_REPO_URI_ROOT=file://$SVN_MIRROR_REPO_PATH_ROOT
TARGETS=( matrix )

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

done

