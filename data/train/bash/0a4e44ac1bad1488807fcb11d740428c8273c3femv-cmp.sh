#!/bin/bash

if [ -z "$1" -o -z "$2" ]
then
	echo -e "\a\nUSO:\n  `basename $0` dir1 dir2\n"
	exit -1
elif [ -n "$3" ]
then
	echo -e "\a\nUSO:\n  `basename $0` dir1 dir2\n"
	exit -1
elif [ "$1" = "$2" ]
then
	echo -e "\a\nUSO:\n  `basename $0` dir1 dir2\n"
	exit -1
elif [ ! -d "$1" -o ! -d "$2" ]
then
	echo -e "\a\nUSO:\n  `basename $0` dir1 dir2\n"
	exit -1
fi

apaga=1
save_pwd=`pwd`
cd "$1"

IFS=$'\n'
for i in `find .`
do

	if [ -d "$i" ]
	then

		mkdir -p "$save_pwd/$2/$i"

	elif [ ! -f "$save_pwd/$2/$i" ]
	then

		mkdir -p "$save_pwd/$2/`dirname "$i"`"
		mv -f "$i" "$save_pwd/$2/$i"

	elif [ -z "`cmp "$i" "$save_pwd/$2/$i" 2>&1`" ]
	then

		rm -f "$i"

	else

		apaga=0
		echo -e "\"$save_pwd/$1/$i\" e \"$save_pwd/$2/$i\" sao diferentes!"

	fi
done

cd "$save_pwd"
if [ "$apaga" = "1" ]
then
	rm -rf "$1"
fi
