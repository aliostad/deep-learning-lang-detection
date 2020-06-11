#!/bin/sh
# $URL$

COMMAND=$(basename $0)

function usage () {
    echo "Usage: $COMMAND repo1..."
    echo "  a 'RPMS' subdir is expected in each repo arg"
    exit 1
}

[[ -n "$@" ]] || usage

set -e 

for repo in "$@" ; do
    if [ ! -d $repo/RPMS ] ; then
	echo could not find $repo/RPMS - ignored
	continue
    fi

    cd $repo
    echo "==================== Dealing with repo $repo"
    mkdir -p PARTIAL-RPMS
    rsync --archive --verbose $(find RPMS -type f | egrep '/(bootcd|bootstrapfs|noderepo|slicerepo)-.*-.*-.*-.*rpm') PARTIAL-RPMS/
    echo "==================== building packages index in $repo .."
    createrepo PARTIAL-RPMS
    echo '==================== DONE'
    cd - >& /dev/null
done
