#!/dev/null
## chunk::92e939c6f33222484d00dbe40c3053fc::begin ##

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

## chunk::3c8b019c663118b00172b22aeae97568::begin ##
if test ! -e "${_temporary}" ; then
	mkdir -- "${_temporary}"
fi
if test ! -e "${_outputs}" ; then
	mkdir -- "${_outputs}"
fi
## chunk::3c8b019c663118b00172b22aeae97568::end ##

## chunk::61abab78b5559f093ec968a2ce332332::begin ##
if test ! -e "${_node_root}" ; then
	mkdir -- "${_node_root}"
fi
if test ! -e "${_node_modules}" ; then
	mkdir -- "${_node_modules}"
fi
if test ! -e "${_node_root}/package.json" ; then
	ln -s -T -- "${_workbench}/package.json" "${_node_root}/package.json"
fi

"${_scripts}/npm" install .

exit 0
## chunk::92e939c6f33222484d00dbe40c3053fc::end ##
