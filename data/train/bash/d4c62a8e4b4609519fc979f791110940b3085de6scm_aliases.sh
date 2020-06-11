# ~/.scm_aliases should redefine the array variable $repositories like so:
#
# repositories+=( foo=svn+ssh://scm.gforge.inria.fr/svn/foobar )

function _scmcheckout_usage() {
	echo "\
Usage: ${1}-checkout [option] repo-path [clone-name]
      --std  use SVN standard layout
      --svn  just do a SVN checkout, not a Git clone
  -h --help
  repository url: ${2}" >&2
}

function _scmcheckout() {
	local name repo command suffix repoPath clone
	name="$1"; repo="$2" # passed by the alias
	shift; shift
	command="git svn clone"
	suffix="gitsvn"
	case "$1" in
	'')
		echo "$name  $repo"
		return;;
	-h | --help)
		shift
		_scmcheckout_usage "$name" "$repo"
		return;;
	--svn)
		command="svn checkout"
		suffix="svn"
		shift;;
	--std)
		command+=" --stdlayout"
		shift;;
	esac
	repoPath="$1"; clone="${2:-`basename "$repoPath"`}.$suffix"
	echo ${command} "${repo}/${repoPath}" "${clone}"
	${command} "${repo}/${repoPath}" "${clone}" && pushd "${clone}"
}

repositories=()
[ -f ~/.scm_aliases ] && . ~/.scm_aliases
for repo in ${repositories[@]}; do
	alias "${repo%%=*}-checkout"="_scmcheckout '${repo%%=*}' '${repo#*=}'"
done
unset repo
