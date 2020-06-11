#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

## chunk::0ff45e3cc94ef8d96696d1e209ac245f::begin ##
_identifier="${1:-0000000000000000000000000000000000000000}"
_fqdn="${mosaic_node_fqdn:-mosaic-0.loopback.vnet}"
_ip="${mosaic_node_ip:-127.0.155.0}"
## chunk::0ff45e3cc94ef8d96696d1e209ac245f::end ##

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

_erl_config="${_erl_libs}/mosaic_httpg/priv/mosaic_httpg.config"

## chunk::b35361a87caab90275af6b199242694a::begin ##
_erl_args+=(
		-noinput -noshell
		-name "${_identifier}@${_fqdn}"
		-setcookie "${_erl_cookie}"
		-boot start_sasl
		-config "${_erl_config}"
)
_erl_env+=(
		mosaic_component_identifier="${_identifier}"
		mosaic_component_temporary="${_tmp}"
		mosaic_node_fqdn="${_fqdn}"
		mosaic_node_ip="${_ip}"
)

if test "${_identifier}" != 0000000000000000000000000000000000000000 ; then
	_erl_args+=(
			-run mosaic_component_app boot
	)
	_erl_env+=(
			mosaic_component_harness_input_descriptor=3
			mosaic_component_harness_output_descriptor=4
	)
	exec 3<&0- 4>&1- </dev/null >&2
else
	_erl_args+=(
			-run mosaic_component_app standalone
	)
fi

_exec=( env "${_erl_env[@]}" "${_erl_bin}" "${_erl_args[@]}" )
## chunk::b35361a87caab90275af6b199242694a::end ##

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
