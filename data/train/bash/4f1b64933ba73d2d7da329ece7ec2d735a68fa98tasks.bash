#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

cat <<EOS

${_package_name}@requisites : \
		pallur-environment

EOS

## chunk::932c58c3bfa226a242ff74d65a335f0b::begin ##
cat <<EOS

${_package_name}@prepare : ${_package_name}@requisites
	!exec ${_scripts}/prepare

${_package_name}@package : ${_package_name}@compile
	!exec ${_scripts}/package

${_package_name}@compile : ${_package_name}@prepare
	!exec ${_scripts}/compile

${_package_name}@publish : ${_package_name}@package
	!exec ${_scripts}/publish

EOS
## chunk::932c58c3bfa226a242ff74d65a335f0b::end ##

exit 0
