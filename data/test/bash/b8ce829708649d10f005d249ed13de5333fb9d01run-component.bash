#!/dev/null

## chunk::0ff45e3cc94ef8d96696d1e209ac245f::begin ##
_identifier="${1:-0000000000000000000000000000000000000000}"
_fqdn="${mosaic_node_fqdn:-mosaic-0.loopback.vnet}"
_ip="${mosaic_node_ip:-127.0.155.0}"
## chunk::0ff45e3cc94ef8d96696d1e209ac245f::end ##

## chunk::c91018535aebeaa9d30f5eb4a51f389b::begin ##
if test -n "${mosaic_component_temporary:-}" ; then
	_tmp="${mosaic_component_temporary}"
elif test -n "${mosaic_temporary:-}" ; then
	_tmp="${mosaic_temporary}/components/${_identifier}"
else
	_tmp="${TMPDIR:-/tmp}/mosaic/components/${_identifier}"
fi
if test "${_identifier}" == 0000000000000000000000000000000000000000 ; then
	_tmp="${_tmp}--${$}--$( date +%s )"
fi
## chunk::c91018535aebeaa9d30f5eb4a51f389b::end ##

_run_bin="${_applications_elf}/component-backend.elf"
_run_env=(
		mosaic_component_identifier="${_identifier}"
		mosaic_component_temporary="${_tmp}"
		mosaic_node_fqdn="${_fqdn}"
		mosaic_node_ip="${_ip}"
)

case "${_identifier}" in
	
	( 00000000190a256e5dcaa1825e8c17117d5415ad )
		if ! test "${#}" -ge 2 ; then
			echo "[ee] invalid arguments; aborting!" >&2
			exit 1
		fi
		_run_args=(
				component-me2-init
				"${@:2}"
		)
	;;
	
	( 0000000000000000000000000000000000000000 )
		if ! test "${#}" -eq 0 ; then
			echo "[ee] invalid arguments; aborting!" >&2
			exit 1
		fi
		_run_args=(
				standalone
		)
	;;
	
	( * )
		if ! test "${#}" -ge 1 ; then
			echo "[ee] invalid arguments; aborting!" >&2
			exit 1
		fi
		_run_args=(
				component
				"${_identifier}"
				"${@:2}"
		)
	;;
esac

_exec=( env "${_run_env[@]}" "${_run_bin}" "${_run_args[@]}" )

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
