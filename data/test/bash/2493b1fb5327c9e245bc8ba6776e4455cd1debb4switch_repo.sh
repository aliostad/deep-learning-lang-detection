#!/bin/bash

REPO_DIR="/u1/memeo/deployment"
USER_DIRS=${REPO_DIR}/*
REPO_USERS=()
 
function show_users {
	for u in ${REPO_USERS[@]};
	 do
		echo $u;
	 done
}

function setup_users {
	REPO_USERS=()
	for u in ${USER_DIRS[@]};
	 do
		REPO_USERS[${#REPO_USERS[*]}]=`basename $u`;
	 done
}

function find_user {
	user=$1
	found=0
	for u in ${REPO_USERS[@]};
	 do
		 if [[ $user == $u ]];
			 then found=1;
		 fi;
	 done
	return $found
}

function find_branch {
	user=$1
	branch_name=$2
	found=0
	cd ${REPO_DIR}/$user
	git fetch origin > /dev/null 2>&1
	branches=$(git branch | sed 's/*//g')	
	for branch in ${branches[@]};
	 do
		if [[ $branch_name == $branch ]];
			then found=1
		fi
	 done
	return $found
}

function clean_up {
	cd $1
}

function switch_repo_usage {
	echo "Usage: switch_repo <user> <branch>"
}

function switch_repo {
	if [ $# -lt 2 ]; then
		switch_repo_usage
		return 1;
	fi

	cur_dir=`pwd`
	setup_users	
	find_user $1
	if [ $? -ne 1 ]; then
		echo "User:" $1 "not found";
		return 1;
	fi
	
	find_branch $1 $2
	if [ $? -ne 1 ]; then
		echo "Branch: $user/"$2 "not found";
		return 1;
	fi

	git reset --hard > /dev/null 2>&1
	git checkout $2 > /dev/null 2>&1

	rm -f ${REPO_DIR}/server > /dev/null 2>&1
	ln -s ${REPO_DIR}/$user  ${REPO_DIR}/server		
	if [ $? -eq 0 ]; then
		logger -t "SWITCH_REPO" Repo switched to $1/$2 at `date`
	else
		logger -t "SWITCH_REPO" Failed Repo switch to $1/$2 at `date`
		clean_up $cur_dir
	fi

	echo "Server Pointing to $1/$2" > BUILD
	clean_up $cur_dir
}

readonly -f show_users
readonly -f setup_users
readonly -f switch_repo
readonly -f clean_up
readonly -f find_user
readonly -f find_branch
export -f switch_repo
