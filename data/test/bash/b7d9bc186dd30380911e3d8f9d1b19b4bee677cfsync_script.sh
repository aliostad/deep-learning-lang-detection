#!/bin/bash

#   CMCompiler is free software. It comes without any warranty, to
#   the extent permitted by applicable law. You can redistribute it
#   and/or modify it under the terms of the Do What The Fuck You Want
#   To Public License, Version 2, as published by Sam Hocevar. See
#   http://sam.zoy.org/wtfpl/COPYING for more details.

CMC="$HOME/.cmcompiler"
CMC_CONF="$CMC/cmcompiler.cfg"

export USE_CCACHE=1

device=$(grep device $CMC_CONF |awk '{print $3}')

repo_path=$(grep repo_path $CMC_CONF |awk '{print $3}')
if [ "$repo_path" == "Default" ]; then
        repo_path="$CMC/build"
fi

if [ ! -d $repo_path ]; then
        mkdir -p $repo_path
fi

branch=$(grep branch $CMC_CONF |awk '{print $3}')

sync_jobs=$(grep sync_jobs $CMC_CONF |awk '{print $3}')
if [ "sync_jobs" == "Default" ]; then
        sync_jobs="4"
fi

chk_repo=$(which repo)
if [ ! -z $chk_repo ]; then
        repo_cmd=$(which repo)
else
        if [ ! -d $CMC/tools ]; then
                mkdir -p $CMC/tools
        fi
        curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > $CMC/tools/repo
        chmod a+x $CMC/tools/repo
        repo_cmd="$CMC/tools/repo"
fi

cd $repo_path
echo "$branch"
echo "$repo_cmd"
if [ ! -d $repo_path/.repo ]; then
        echo "0"
        if [ "$branch" == "gingerbread" ]; then
                echo "1"
                $repo_cmd init -u https://github.com/CyanogenMod/android.git -b gingerbread
        elif [ "$branch" == "ics" ]; then
                echo "2"
                $repo_cmd init -u https://github.com/CyanogenMod/android.git -b ics
        else
                echo "No branch selected, exiting"
                exit 1
        fi
fi

$repo_cmd sync -j$sync_jobs
