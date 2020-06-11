#!/dev/null

_identifier="0000000000000000000000000000000000000000"

## chunk::1a3fcfc1466c5818383908400b4bac35::begin ##
if test "${#}" -ge 1 ; then
	for _argument in "${@}" ; do
		if test -z "${_identifier}" ; then
			_identifier="${_argument}"
			break
		fi
		case "${_argument}" in
			( --component-identifier )
				_identifier=''
			;;
		esac
	done
fi
## chunk::1a3fcfc1466c5818383908400b4bac35::end ##

## chunk::c91018535aebeaa9d30f5eb4a51f389b::begin ##
if test -n "${mosaic_component_temporary:-}" ; then
	_tmp="${mosaic_component_temporary:-}"
elif test -n "${mosaic_temporary:-}" ; then
	_tmp="${mosaic_temporary}/components/${_identifier}"
else
	_tmp="${TMPDIR:-/tmp}/mosaic/components/${_identifier}"
fi
if test "${_identifier}" == 0000000000000000000000000000000000000000 ; then
	_tmp="${_tmp}--${$}--$( date +%s )"
fi
## chunk::c91018535aebeaa9d30f5eb4a51f389b::end ##

if test -n "${mosaic_component_debug:-}" ; then
	_java_args+=( -Dlogback.levels.root=debug )
fi

_jar="${_java_jars:-${_outputs}/${_pom_group}--${_pom_artifact}--${_pom_version}/target}/${_package_jar_name}"

_java_args+=(
		-jar "${_jar}"
		"${@}"
)

_exec=( env "${_java_env[@]}" "${_java_bin}" "${_java_args[@]}" )

## chunk::28123944cc9e9fddd23208a1405324fb::begin ##
mkdir -p -- "${_tmp}"
cd -- "${_tmp}"

exec {_lock}<"${_tmp}"
if ! flock -x -n "${_lock}" ; then
	echo '[ee] failed to acquire lock; aborting!' >&2
	exit 1
fi

if test -n "${mosaic_component_log:-}" ; then
	exec 2>"${mosaic_component_log}"
fi

exec "${_exec[@]}"

exit 1
## chunk::28123944cc9e9fddd23208a1405324fb::end ##
