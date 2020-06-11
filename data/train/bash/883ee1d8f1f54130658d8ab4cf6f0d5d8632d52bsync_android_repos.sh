#!/bin/bash
# This file is in PUBLIC DOMAIN. You can use it freely. No guarantee.
#
# This file is used to clone/sync Android's Code for Windows (msysgit).
# @author Fan Hongtao <fanhongtao@gmail.com>

# create directory if it doesn't exist
function create_dir()
{
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

function create_project_list()
{
    cd $base_dir
    if [ ! -d ".repo" ]; then
        mkdir ".repo"
    fi

    cd .repo
    project="manifest"

    if [ -d $project ]; then
        pull_repo $project
    else
        git clone $repo_base_url/platform/manifest
    fi

    cd $base_dir
    grep "project path" .repo/manifest/default.xml | awk -F\" '{ print $2, $4 }' > $project_file

    if [ ! -f $project_file ]; then
        echo "Can't find file $project_file"
        exit 1
    fi
}

function clone_repo()
{
    repo=$1
    remote_dir=$2
    repo_name=${repo##*/}
    if [ $repo != $repo_name ]; then
        repo_path=${repo%/*}
        create_dir  $repo_path
        cd $repo_path
    fi

    repo_url=${repo_base_url}/${remote_dir}
    git clone $repo_url
    echo
}

function pull_repo()
{
    repo_dir=$1
    echo "Pulling $repo_dir ..."
    cd $repo_dir
    git pull
    echo
}

base_dir=`pwd`
project_file=".repo/project.list"
repo_base_url="https://android.googlesource.com"
create_project_list

cd $base_dir
# Clone/pull repositories listed in the project.list
while read line
do
    cd $base_dir
    local_dir=`echo $line | awk '{print $1}'`
    remote_dir=`echo $line | awk '{print $2}'`
    if [ -d $local_dir ]; then
        pull_repo ${base_dir}/${local_dir}
    else
        clone_repo $local_dir $remote_dir
    fi
done < $project_file

