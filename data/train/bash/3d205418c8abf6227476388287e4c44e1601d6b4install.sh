#!/bin/sh
set -e
REPO_NAME="cog"
REPO_URL="https://github.com/chutsu/$REPO_NAME"
INSTALL_COMMAND="make; make run_tests; sudo make install"

confirm()
{
    read -p "$@ (y/n): " choice
    case "$choice" in
        y|Y ) echo "1";;
        n|N ) echo "0";;
        * ) echo "-1" ;;
    esac
}

confirm_install()
{
    DO_INSTALL=$(confirm "WARN: Are you sure you want to install $REPO_NAME?")
    if [ "$DO_INSTALL" -eq "1" ]; then
        install
    elif [ "$DO_INSTALL" -eq "-1" ]; then
        echo "Error: Invalid option! Please enter y or n!"
    else
        echo "Not installing $REPO_NAME ..."
    fi
}

install()
{
    # download repo
    git clone $REPO_URL

    # make
    cd $REPO_NAME
    eval $INSTALL_COMMAND
    cd ..
    rm -rf $REPO_NAME
}

run()
{
    if [ $# -eq 0 ]; then
        confirm_install
    elif [ "$@" == "--yes" ]; then
        install
    else
        echo "invalid argument!"
    fi
}

# RUN
run $1
