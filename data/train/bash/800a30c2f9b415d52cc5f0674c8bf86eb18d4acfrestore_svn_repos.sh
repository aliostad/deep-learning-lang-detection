#!/bin/sh
#
# Description:
#   Restore all subversion repositorys from a compressed dump file
# Requirements:
#   Subversion
#   pigz or gzip
# Example Usage:
#   Set REPODIR and BACKUPDIR, then just run it without args
#

REPODIR=/var/lib/svn
BACKUPDIR=/data/backups/svn
COMP_TOOL=gzip
which pigz >/dev/null && COMP_TOOL=pigz

for REPO in `ls $REPODIR`; do
	REPOFAIL=0

	if [ ! -d $REPODIR/$REPO ]; then
		echo "Cannot find repo: $REPO" 
		echo "You need to create the repo before you can load a dump into it"
		REPOFAIL=1
	fi

	if [ ! -f $BACKUPDIR/${REPO}.svn.gz ]; then
		echo "Cannot find repo backup: ${REPO}.svn.gz" 
		REPOFAIL=1
	fi
	
	if [ $REPOFAIL -eq 0 ]; then
		echo "Importing repo: ${REPO}..."
		$COMP_TOOL -d -c ${REPO}.svn.gz | svnadmin load $REPODIR/$REPO
		if [ "$?" -eq 0 ]; then
			echo "Imported $REPO successfully."
		else
			echo "Importing repo $REPO failed!"
		fi
	else
		echo "Importing repo $REPO failed!"
	fi
done

