#!/bin/sh

# config vars
input_id=
input_username=
input_password=
input_bkpPath=
id=
username=
password=
bkpPath=
save_id=
save_username=
save_password=
save_bkpPath=

# read input parameter
readParameter() {
	if [ "$1" = "-?" ]; then
		echo $TEXT_HELP
		exit 1
	elif [ "$1" = "--help" ]; then
		echo $TEXT_HELP
		exit 1
	fi

	while getopts hi:p:u: option
	do	case "$option" in
		h)	echo $TEXT_HELP
			exit 1;;
		i)	input_id="$OPTARG";;
		p)	input_password="$OPTARG";;
		u)	input_username="$OPTARG";;
		esac
	done	
}

# read id if not given as parameter
readBackupPath() {
	if [ $input_bkpPath ]; then
		# save previous bkpPath
		save_bkpPath="bkpPath=$bkpPath"

		bkpPath=$input_bkpPath
	elif [ ! $bkpPath ]; then
		echo "Backup path?"
		read bkpPath
		save_bkpPath="bkpPath=$bkpPath"
	else
		save_bkpPath="bkpPath=$bkpPath"
	fi
	
	if [[ ! -d $bkpPath && ! -L $bkpPath ]]; then
		echo "$TEXT_NO_DIR ($bkpPath)"
		exit 1
	elif [ ! -w $bkpPath ]; then
		echo "$TEXT_NO_WRITEABLE_DIR ($bkpPath)"
		exit 1
	fi
}

# read id if not given as parameter
readId() {
	if [ $input_id ]; then
		# save previous id
		save_id="id=$id"

		id=$input_id
	elif [ ! $id ]; then
		echo "id?"
		read id
		save_id="id=$id"
	else
		save_id="id=$id"
	fi
}

# read username if not given as parameter
readUsername() {
	if [ $input_username ]; then
		# save previous username
		save_username="username=$username"

		username=$input_username
	elif [ ! $username ]; then
		echo "name?"
		read username
		save_username="username=$username"
	else
		save_username="username=$username"
	fi
}

# read password if not given as parameter
readPassword() {
	if [ $input_password ]; then
		# save previous pw
		save_password="password=$password"

		password=$input_password
	elif [ ! $password ]; then
		echo "pw?"
		read password

		echo "save?"
		read save_password

		save_password="$(echo ${save_password} | tr 'A-Z' 'a-z')"
		if [ "$save_password" = "y" ]; then
			save_password="password=$password"
		else
			save_password=
		fi
	else
		save_password="password=$password"
	fi
}