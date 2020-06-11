#!/bin/bash

# Author: Moritz Bellach
# Version: 1

if [[ (($# -ne 1) && ($# -ne 2)) || ($1 == "-h") ]]; then
  echo "usage: bak.sh <file or dir> <optional tag>"
  echo "files will just be copied"
	echo "directories will be archieved as .tgz"
	exit
fi

APPEND="bak-`date +'%Y-%m-%d_%H%M%S'`"

if [ $# -eq 2 ]; then
	APPEND="${APPEND}-${2}"
fi

if [ -d $1 ]; then
	APPEND="${APPEND}.tgz"
	echo "backing up ${1} to ${1}.${APPEND}"
	tar czf $1.$APPEND $1
else
	echo "backing up $1 to ${1}.${APPEND}"
	cp -p $1 $1.$APPEND
fi
