#!/bin/bash

# This script should take exactly one argument, a file.  It should
# invoke emacs on the file if the file has a txt extension.  It should
# invoke firefox on the file if the file has a html extension.  It
# should invoke evince on the file if the file has a pdf extension.
# It should exit reporting error if the file has no extension or if it
# has some other extension

if [ "$#" -ne 1 ];then
    echo "Error : Wrong number of arguments."
    echo "Usage : $0 FileName "
    exit 1
fi

extension=`basename $1|cut -f2 -d'.'`
if [ "$extension" = "$1" ];then
    echo "The file has no extension, program will now exit!"
    exit 1
fi

case "$extension" in 
    [tT][Xx][Tt]) eval 'emacs $1'
        ;;
    [Hh][Tt][Mm][Ll])eval 'firefox $1'
        ;;
    [Pp][Dd][Ff])eval 'evince $1'
        ;;
    *) echo "I don't know what to do with this extension, the program will now exit!"
        exit 1
esac



