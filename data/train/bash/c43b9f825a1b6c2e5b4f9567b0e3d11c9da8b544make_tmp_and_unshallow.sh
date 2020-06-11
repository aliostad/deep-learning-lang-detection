#!/usr/bin/env bash
## make_tmp_and_unshallow.sh REPO_URL TMP CLONED_REPO
script_name=$0
repo_url=$1
tmp=$2
cloned_repo=$3

git clone --progress --mirror $cloned_repo $tmp && \
cd $tmp && \
git remote set-url origin $repo_url && \
git fetch --unshallow --progress && \
cd $cloned_repo && \
git remote add tmp $tmp && \
git fetch tmp --unshallow --progress && \
# fix origin, to be able to fetch all branches
git config --replace-all \
    remote.origin.fetch +refs/heads/*:refs/remotes/origin/* &&\
git fetch --all --progress
echo $0" "$1" "$2" "$3" done!"