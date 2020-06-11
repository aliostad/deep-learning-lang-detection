#!/bin/bash

local_gitrepo=/opt/git-repo
local_cloudify_repo=$local_gitrepo/cloudify
local_openspaces_repo=$local_gitrepo/openspaces
local_openspaces_scala_repo=$local_gitrepo/openspaces-scala
local_gigaspaces_repo=$local_gitrepo/gigaspaces

if [ $# -ne 2 ]; then
    echo WRONG USAGE!!! You must supply 2 parameters:
    echo USAGE: ./add-new-repo.sh repo_name git_url
    exit 1
fi

repo_name=$1
git_url=$2

repo_dir=$local_gitrepo/$repo_name


pushd $local_gitrepo
	git svn clone svn://pc-lab14/SVN/xap/trunk/$repo_name

		pushd $repo_dir
			git remote add origin $git_url
			git push origin master

	popd
popd
