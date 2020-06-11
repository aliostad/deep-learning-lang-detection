#!/bin/bash
#
# update-rpm-repo.sh - Ensure RPMs in repo directory are usable by YUM
#

# Sanity checks to ensure we got the rpm-repo-dir arg
if test $# -ne 1 ; then
    echo "Usage: `basename $0` rpm-repo-dir"
    exit -1
fi

if ! test -d "$1" ; then
    echo "'$1' is not a directory"
    exit -1
fi

RPM_REPO_DIR="$1"

# Make SELinux happy
chcon unconfined_u:object_r:httpd_sys_content_t:s0 $RPM_REPO_DIR/x86_64/*.rpm
chcon unconfined_u:object_r:httpd_sys_content_t:s0 $RPM_REPO_DIR/SRPMS/*.rpm

# Update repo metadata
createrepo -d $RPM_REPO_DIR/x86_64
createrepo -d $RPM_REPO_DIR/SRPMS
