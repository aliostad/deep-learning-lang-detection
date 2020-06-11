#!/bin/bash

# This script should take exactly one argument, a file.  It should
# invoke emacs on the file if the file has a txt extension.  It should
# invoke firefox on the file if the file has a html extension.  It
# should invoke evince on the file if the file has a pdf extension.
# It should exit reporting error if the file has no extension or if it
# has some other extension

function usage(){
	echo -n "Usage: "
	echo $0" filename"
}

function openProgram(){
	case ${1##*.} in
		"txt" )
			emacs $1& ;;
		"html" )
			firefox $1& ;;
		"pdf" )
			evince $1&;;
		* )
			echo "Invalid extension!"
			exit 1
	esac
}

if ! [ $# -eq 1 ]; then
	usage
	exit 1
fi

openProgram $1
