#!/bin/bash -eu

#Add a new svn repository
#Eventually this should be able to add a new user as well.
SVN_ADMIN=mnishizawa

repo_name=$1;
repo_path="/var/svn/${repo_name}"
repo_devgroup="${repo_name}-dev"

if [ ! "${repo_name}" ]; then
   echo "Usage: $0 <repository_name>"
   exit 1
fi

#create the directory in /var/svn
mkdir -p $repo_path

#initialize the repository
svnadmin create $repo_path

#create the group with write access
groupadd $repo_devgroup

#set permissions on the repo
chown -R $SVN_ADMIN:$repo_devgroup $repo_path
chmod -R g+w $repo_path/db
chmod 750 $repo_path

#set up the repo structure
mkdir -p /tmp/svnrepo/template/trunk
mkdir /tmp/svnrepo/template/tags
mkdir /tmp/svnrepo/template/branches

svn import -m "initial structure" /tmp/svnrepo/* file://localhost/$repo_path

rm -rf /tmp/svnrepo

echo "Repository ${repo_name} configured successfully.  Please add the appropriate users to the group '${repo_devgroup}'"

