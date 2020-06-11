#!/bin/bash
if [ ! -d $github ]; then
	echo "\$github is not a dir"
	echo "pls set it up, like:"
	echo "export github=/the/path/to/store/your/repos/forked/from/github"
	exit
fi

echo CURRENT_DIR= `pwd`
REPO=${1#"https://github.com/"}
REPO=${REPO#"http://github.com/"}
REPO=${REPO#"git://github.com/"}
echo "repo: $REPO"

if [ $# -ne 1 -a $# -ne 2 ]; then
	echo "\033[31m Usage: $0 [repo] dir \033[0m"
	echo "\033[31m repo=https://github.com/abc/xyz \033[0m"
	echo "\033[31m or repo=http://github.com/abc/xyz \033[0m"
	echo "\033[31m or repo=git://github.com/abc/xyz \033[0m"
	echo "\033[31m or repo=abc/xyz \033[0m"
	exit
fi

if [ $# -eq 2 ]; then
	echo "git clone https://github.com/$REPO $2"
	read -n1 -p "Do you want to continue [Y/N]?" answer 
	case $answer in 
	Y | y)
		echo "loading..."
		git clone "https://github.com/$REPO" $2
	;;
	N | n)
		echo "cancled..."
		exit
	;;
	*)
		echo "error choice"
		exit
	;;
	esac 
else
	echo "path: $github/$REPO"
#	pushd /media/akio/linux-data/open-src/github
#	if [ ! -d "./$REPO" ]; then
#        	"mkdir -p $REPO"
#	        mkdir -p $REPO
#	fi
#	pushd $REPO/../	
	git clone "https://github.com/$REPO" "$github/$REPO"
#	popd
	pushd "$github/$REPO"
#	cd $CURRENT_DIR
fi
