#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

function viewgit(){
    for ((i=0;i<${#git_dir[*]};i++))
    do
        repo_name=$(echo ${git_dir[$i]} | cut -d "/" -f 4- | cut -d "." -f 1)
        repo_path=$(echo ${git_dir[$i]})
        echo "'${repo_name}' => array('repo' => '${repo_path}'),"
    done
}

function cgit(){
    for ((i=0;i<${#git_dir[*]};i++))
    do
        repo_name=$(echo ${git_dir[$i]} | cut -d "/" -f 4- | cut -d "." -f 1)
        repo_path=$(echo ${git_dir[$i]})
        repo_description=$(cat ${git_dir[$i]}/description 2> /dev/null)
        echo "repo.url=${repo_name}"
        echo "repo.path=${repo_path}"
        echo -e "repo.desc=${repo_description}\n"
    done
}

read -p "Input repository root directory: " repo_root_dir

if [ ! -d "$repo_root_dir" ];then
    echo "$repo_root_dir is not exist"
    exit 0
fi
 
git_dir=( $(find $repo_root_dir -regextype posix-basic -type d -regex ".*[[:alnum:]]\.git$" | grep -Ev "backup|os.20121012|\
gitolite-admin|oldproject") )

if [ "$1" == "viewgit" ];then
    viewgit;
elif [ "$1" == "cgit" ];then
    cgit;
else
    exit 1
fi
