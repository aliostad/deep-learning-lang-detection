#!/bin/bash
echo My name is $0
echo My process number is $$
echo I have $# arguments
echo My arguments separately are $*
echo My arguments together are "$@"
echo My 5th argument is "'$5'"
echo The return value of last command $?
usage() {
	echo "Usage: $0 filename"
	exit 1 } 
is_file_exits(){
	local f="$1"
	[[ -f "$f" ]] && return 0 || return 1 }
# invoke  usage
# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage
# Invoke is_file_exits
if ( is_file_exits "$1" )
then
 echo "File found"
else
 echo "File not found"
fi