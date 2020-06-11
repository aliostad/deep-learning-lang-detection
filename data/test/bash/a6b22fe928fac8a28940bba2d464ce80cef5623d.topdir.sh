# UI part of rg.rdir.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_rdir_help() {
            cat <<EOF
Usage: $TOPDIR_SH_INFO [options]

Print the root-path of a repo. "Repo" in this contex means a google repo, i.e.
the complete structure managed by a manifest under a subdir ~/.repo, whereas
"repo" means repository in a generic form.

Options:
  -d          Directory start-pointer. Note: may be anywhere in a repo
  -G          Type of repo is git
  -R          Type of repo is Repo
  -h          This help

Example:
  $TOPDIR_SH_INFO -d ~/mydroid/xx/yy

EOF
}
	while getopts RGhd: OPTION; do
		case $OPTION in
		h)
			print_rdir_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		G)
			REPO_TYPE="git"
			;;
		R)
			REPO_TYPE="repo"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_rdir_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	START_DIR=${START_DIR-$(pwd)}
	REPO_TYPE=${REPO_TYPE-"repo"}

