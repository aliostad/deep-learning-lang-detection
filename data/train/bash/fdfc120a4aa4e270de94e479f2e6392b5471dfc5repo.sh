repo_create() {
	if [ $1 ]; then
		mkdir -p $1
		if [ -d $1 ]; then
			repo_arch=`basename $1`
			full_path=`cd $1 ; pwd`
			repo_conf=${full_path}/${repo_name}.conf
			db_dir=${full_path}/${repo_arch}_db
			conf_file=${full_path}/pacman.${repo_arch}.conf
			wget -P $full_path ${master_url}/pacman.${repo_arch}.conf
			if [ $? -ne 0 ]; then
				echo "Config download failed!"
				echo "Invalid architecture '${repo_arch}' or broken master url"
				exit 1
			fi
			mkdir $db_dir &&
			mkdir ${full_path}/package_lists
			if [ ! -f  $repo_conf ]; then
				touch $repo_conf
				echo "pac_opts=\"--noconfirm --config $conf_file --dbpath $db_dir --cachedir $full_path\"" >> $repo_conf
			fi
		fi
	fi
}

repo_fetch () {
	if [ $USER != "root" ]; then
		echo "march update requires root privileges!"
		exit 1
	fi
	if [ $1 ];  then
		if [ -f $1/${repo_name}.conf ]; then
			source $1/${repo_name}.conf
			pacman -Syu
			ls $1/package_lists/*.list &> /dev/null
			if [ $? -eq 0 ]; then
				pacman $pac_opts -Syy
				pacman $pac_opts -Sw `cat $1/package_lists/*.list`
			else
				echo "No package lists available for $1"
				echo "See: $0 list add"
			fi
		else
			echo "Invalid repo or missing config file: $1"
		fi
	else
		echo "Example usage: $0 fetch ./i686"
	fi
}

repo_update() {
	if [ $1 ] && [ -d $1 ]; then
		repo-add $1/${repo_name}.db.tar.gz $1/*.pkg.tar.xz
		exit 0
	else
		echo "Example usage: $0 update ./i686"
		exit 1
	fi
}

mod_repo() {
	help () {
		echo "Usage: $0 repo <create|update> <repo path>"
		echo "Example: $0 repo create ~/localrepo/i686"
	}
	if [ $# -ge 2 ]; then 
		case "$1" in
			create)
				repo_create $2
				;;
			update)
				repo_fetch $2 &&
				repo_update $2
				;;
			*)
				help
				;;
		esac
	else
		help
	fi

}
