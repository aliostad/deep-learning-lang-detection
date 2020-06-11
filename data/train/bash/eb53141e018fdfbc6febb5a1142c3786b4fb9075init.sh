#!/bin/bash
export SOURCE_REPO=
export TARGET_REPO=
export REPO_NAME=gitrepository.git
export DIR=`dirname $0`
source "${DIR}/common.sh" 

usage() {
	cat <<EOF

	Usage:

	gitsync init -s <source> -t <target> [-n <name>]

EOF

}

interact() {
	
	while [ -z $SOURCE_REPO ]; do
		echo "What repository do you want to clone?"
		read SOURCE_REPO
		
	done

	while [ -z $TARGET_REPO ]; do
		echo "What repository do you want to push changes to?"
		read TARGET_REPO
	done

	echo "What is the name of this project?"
	read NAME
	if [ -n "$NAME" ]; then
		REPO_NAME=$NAME
	fi

}

validate_args() {

	if [ -d "${WORKDIR}" ]; then
		echo "Project already exists"
		exit
	fi

	if [ -z $SOURCE_REPO ]; then
		echo "Source repository not set"
		usage
		exit -1
	fi

	if [ -z $TARGET_REPO ]; then
	  echo "Target repository not set"
	  usage
	  exit -1
	fi

}

do_init() {
	if [ -d $WORKDIR ]; then
		echo "Workdir already created - exiting"
		exit
	fi
	
	mkdir -p $WORKDIR
	cat <<EOF > "${WORKDIR}/.gitsync"
SOURCE_REPO=${SOURCE_REPO}
TARGET_REPO=${TARGET_REPO}
REPO_NAME=${REPO_NAME}
EOF

}

clone_repo() {
	git clone --mirror ${SOURCE_REPO} "${WORKDIR}/${REPO_NAME}"
	echo "Repository ${SOURCE_REPO} cloned - run gitsync sync to synchronise. Note that nothing has been pushed to ${TARGET_REPO} yet"
}

while getopts :s:t:n: OPT
do case "$OPT" in
  s) SOURCE_REPO=$OPTARG;;
  t) TARGET_REPO=$OPTARG;;
	n) REPO_NAME="${OPTARG}.git";;
  ?) usage;exit 0;;
  esac
done

if [ $# -eq 0 ]; then
	interact
fi

validate_args
do_init
clone_repo