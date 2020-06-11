#! /bin/bash
#
# repo_init.sh
# Copyright (C) 2015 zach <zach@1404desktop-790>
#
# Distributed under terms of the MIT license.
#
mybase="https://github.com/zach2014"
inited=false
[ "$1" = "-e" ]  && {
    inited=true
    shift
}

[ $1 ] || {
    echo -n "usage:"
    echo -e "$0 [-e] <repo> [github-url]"
    echo -e "\toption: [-e] : repo has been initialized by 'git init' "
    exit 1
}

repo=$1
[ $2 ] &&  mybase=$2 

echo -e  "An repo will be create at $mybase/$repo.git"
if ! $inited ; then 
git init 
if ! [ -f README.md ]; then 
echo "$repo" >> README.md
fi
git add -A  
git commit -m "init $repo"
fi
git remote add origin $mybase/$repo.git
git push -u origin master

