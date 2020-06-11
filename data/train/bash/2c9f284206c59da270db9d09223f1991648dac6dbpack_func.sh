#!/bin/bash

function bpack_check_project_root()
{
	if [ ! -L ./lib/bPack ]; then
		response "$error" "bPack script should call from project root directory"
	fi

	return
}

function bpack_create_model()
{
	echo

	if [ ! -e ./model/Model ]; then
		echo "Model directory not exists, we build one."
		mkdir ./model/Model
	fi

	if [ -e "./model/Model/$1.php" ]; then
		response "$existed" "Model [$1]"
		response "$deleted" "Model [$1]"
		rm "./model/Model/$1.php"
	fi
	
	php "$bPack_Directory/generate_model.php" "$1" "$2" "$3"
	response "$created" "Model [$1]"

	echo

	return
}
