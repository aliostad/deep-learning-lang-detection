#!/bin/bash


if [ "$1" = "" ]
then
    echo "Missing lecture name"
    exit 1
fi

LECTURE="$*"
DIR_NAME=$(echo $LECTURE | sed 's, ,\-,g')

mkdir $DIR_NAME
mkdir $DIR_NAME/doc
touch $DIR_NAME/doc/introduction.md

save_makefile(){
    echo "$*" >> $DIR_NAME/Makefile
}

save_makefile "NAME=$(echo $LECTURE)"
save_makefile "TYPE="
save_makefile "LOS="
save_makefile ""
save_makefile "EDU_ORGANIZER_PATH=$(dirname $0 | sed -e's,bin*,,g' -e 's,/$,,g')/"
save_makefile 'include $(EDU_ORGANIZER_PATH)/makefiles/lectures.mk'




    

