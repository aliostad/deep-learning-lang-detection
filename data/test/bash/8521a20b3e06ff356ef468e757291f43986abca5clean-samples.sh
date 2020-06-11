#!/bin/sh
# -*- coding: utf-8-unix -*-

if [ -d 1-git-sample -a -e 1-git-sample/.git ]; then
    echo removing 1-git-sample
    rm -f -r 1-git-sample
fi

if [ -d 2-git-sample -a -e 2-git-sample/.git ]; then
    echo removing 2-git-sample
    rm -f -r 2-git-sample
fi

if [ -d repo-2-git-sample.git -a -f repo-2-git-sample.git/HEAD ]; then
    echo removing repo-2-git-sample.git
    rm -f -r repo-2-git-sample.git
fi

if [ -d 3-git-sample -a -e 3-git-sample/.git ]; then
    echo removing 3-git-sample
    rm -f -r 3-git-sample
fi
