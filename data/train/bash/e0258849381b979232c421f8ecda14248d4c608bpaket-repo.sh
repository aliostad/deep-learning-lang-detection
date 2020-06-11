#!/bin/sh

#
_paket_repo_usage () {
	echo "usage: paket repo [options] ppa:<username>/<ppa-name>"
	echo "\t -i - installs ppa"
	echo "\t -r - removes ppa"
	echo "\t -p - purges ppa and reverts to official packages"
	#echo -e "\t -f - check if ppa is installed"
}

# installs a package from a local package file
_paket_repo_add () {
	sudo apt-add-repository $@
}

#
_paket_repo_remove () {
	sudo apt-add-repository -r $@
}

#
_paket_repo_purge () {
	sudo ppa-purge $@
}

#
#_paket_repo_find () {
#}

# installs a package
paket_repo () {
	which apt-add-repository > /dev/null
	[ $? ] || {
		echo "Could not find dependency apt-add-repository!"
		exit 1
	}

	which ppa-purge > /dev/null
	[ $? ] || {
		echo "Could not find dependency ppa-purge!"
		exit 1
	}

	# check for arguments
	[ $# -eq 0 ] && {
		# if there is no parameter
		# print usage
		_paket_repo_usage
	} || {
		# pop parameter 1
		local cmd="$1"
		shift

		# switch on command
		case "$cmd" in
			"-i") {
				[ $# -eq 0 ] && {
					_paket_repo_usage
					exit 1
				}

				_paket_repo_add $@
			} ;;

			"-r") {
				[ $# -eq 0 ] && {
					_paket_repo_usage
					exit 1
				}

				_paket_repo_remove $@
			} ;;

			"-p") {
				[ $# -eq 0 ] && {
					_paket_repo_usage
					exit 1
				}

				_paket_repo_purge $@
			} ;;

			*) {
				_paket_repo_usage
			} ;;
		esac
	}
}

paket_repo $@
