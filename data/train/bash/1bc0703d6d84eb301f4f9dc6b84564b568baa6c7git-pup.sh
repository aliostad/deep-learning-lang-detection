#!/bin/bash
# Exists to fully update the git repo that you are sitting in...
# Author: Marc Cluet <marc.cluet@rackspace.com>

# By default it will init all submodules, but you can also update and status

case "$2" in
    internal)
        REPOLIST=`grep -B1 -E 'url.*github.rackspace.com' .gitmodules | awk '/path/ {print $NF}'`
        ;;
    external)
        REPOLIST=`grep -B1 -E 'url.*github.com' .gitmodules | awk '/path/ {print $NF}'`
        ;;
    *)
        REPOLIST=`grep -B1 -E 'url' .gitmodules | awk '/path/ {print $NF}'`
        ;;
esac

case "$1" in
    update)
        git pull 2>&1 > /dev/null
        for REPO in $REPOLIST
        do
            echo "Updating submodule: $REPO"
            git submodule update $REPO
            git submodule status $REPO
        done
        ;;
    status)
        git pull 2>&1 > /dev/null
        for REPO in $REPOLIST
        do
            git submodule status $REPO
        done
        ;;
    *)
        git pull 2>&1 > /dev/null
        for REPO in $REPOLIST
        do
            echo "Updating submodule: $REPO"
            git submodule init $REPO
            git submodule update $REPO
            git submodule status $REPO
        done
        ;;
esac
