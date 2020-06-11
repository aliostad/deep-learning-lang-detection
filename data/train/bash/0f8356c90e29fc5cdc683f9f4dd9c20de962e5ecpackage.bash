#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

## chunk::d1dfca51fec7f64f5d67609f4980d1b4::begin ##
if test -e "${_outputs}/package" ; then
	chmod -R +w -- "${_outputs}/package"
	rm -R -- "${_outputs}/package"
fi
if test -e "${_outputs}/package.cpio.gz" ; then
	chmod +w -- "${_outputs}/package.cpio.gz"
	rm -- "${_outputs}/package.cpio.gz"
fi

mkdir -- "${_outputs}/package"
mkdir -- "${_outputs}/package/bin"
mkdir -- "${_outputs}/package/lib"
mkdir -- "${_outputs}/package/lib/scripts"
## chunk::d1dfca51fec7f64f5d67609f4980d1b4::end ##

cat >"${_outputs}/package/lib/scripts/_do.sh" <<'EOS--09ae793435af6ff456e68c1671743722'
#!/bin/bash
## chunk::09ae793435af6ff456e68c1671743722::begin ##

## chunk::c766649a978d19b4ca6f7d8d1740eb1b::begin ##
set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

_self_basename="$( basename -- "${0}" )"
_self_realpath="$( readlink -e -- "${0}" )"
cd -- "$( dirname -- "${_self_realpath}" )"
cd -- ../..
_package="$( readlink -e -- . )"
cmp -s -- "${_package}/lib/scripts/_do.sh" "${_self_realpath}"
test -e "${_package}/lib/scripts/${_self_basename}.bash"
## chunk::c766649a978d19b4ca6f7d8d1740eb1b::end ##

## chunk::e8e633c1ba85cb854e1f1d77d5f94d94::begin ##
if test -e "${_package}/env/paths" ; then
	test -d "${_package}/env/paths"
	_PATH="$(
			find "${_package}/env/paths" -xdev -mindepth 1 -maxdepth 1 -type l -xtype d \
			| sort \
			| while read -r _path ; do
				printf ':%s' "$( readlink -m -- "${_path}" )"
			done
	)"
	_PATH="${_PATH_extra:-}${_PATH}"
	_PATH="${_PATH/:}"
	export -- PATH="${_PATH}"
else
	_PATH="${_PATH_extra:-}:${PATH:-}"
	_PATH="${_PATH/:}"
	export -- PATH="${_PATH}"
fi

if test -e "${_package}/env/variables" ; then
	test -d "${_package}/env/variables"
	while read -r _path ; do
		_name="$( basename -- "${_path}" )"
		case "${_name}" in
			( @a:* )
				test -L "${_path}"
				_name="${_name/*:}"
				_value="$( readlink -e -- "${_path}" )"
			;;
			( * )
				echo "[ee] invalid variable \`${_path}\`; aborting!"
				exit 1
			;;
		esac
		export -- "${_name}=${_value}"
	done < <(
			find "${_package}/env/variables" -xdev -mindepth 1 \
			| sort
	)
fi
## chunk::e8e633c1ba85cb854e1f1d77d5f94d94::end ##

## chunk::1972c9ccaf7f6e27c0c448294e0e9b87::begin ##
if test "${#}" -eq 0 ; then
	. -- "${_package}/lib/scripts/${_self_basename}.bash"
else
	. -- "${_package}/lib/scripts/${_self_basename}.bash" "${@}"
fi

echo "[ee] script \`${_self_main}\` should have exited..." >&2
exit 1
## chunk::1972c9ccaf7f6e27c0c448294e0e9b87::end ##
## chunk::09ae793435af6ff456e68c1671743722::end ##
EOS--09ae793435af6ff456e68c1671743722

chmod +x -- "${_outputs}/package/lib/scripts/_do.sh"

for _script_name in "${_package_scripts[@]}" ; do
## chunk::cd272b06265b6e7f94a1bfe0bb8c206f::begin ##
	test -e "${_scripts}/${_script_name}" || continue
	if test -e "${_scripts}/${_script_name}.bash" ; then
		_script_path="${_scripts}/${_script_name}.bash"
	else
		_script_path="$( dirname -- "$( readlink -e -- "${_scripts}/${_script_name}" )" )/${_script_name}.bash"
	fi
	cp -T -- "${_script_path}" "${_outputs}/package/lib/scripts/${_script_name}.bash"
	ln -s -T -- ./_do.sh "${_outputs}/package/lib/scripts/${_script_name}"
	cat >"${_outputs}/package/bin/${_package_name}--${_script_name}" <<EOS--5690bb4114b0428099a9b63f75de8406
#!/bin/bash
## chunk::5690bb4114b0428099a9b63f75de8406::begin ##
set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "\${BASH_COMMAND}" >&2' ERR || exit 1
if test "\${#}" -eq 0 ; then
	exec -- "\$( dirname -- "\$( readlink -e -- "\${0}" )" )/../lib/scripts/${_script_name}" || exit 1
else
	exec -- "\$( dirname -- "\$( readlink -e -- "\${0}" )" )/../lib/scripts/${_script_name}" "\${@}" || exit 1
fi
exit 1
## chunk::5690bb4114b0428099a9b63f75de8406::end ##
EOS--5690bb4114b0428099a9b63f75de8406
	chmod +x -- "${_outputs}/package/bin/${_package_name}--${_script_name}"
## chunk::cd272b06265b6e7f94a1bfe0bb8c206f::end ##
done

## chunk::3b87aa53ffaed5f9c0426a6bbed5704a::begin ##
chmod -R a+rX-w,u+w -- "${_outputs}/package"

cd "${_outputs}/package"
find . \
		-xdev -depth \
		\( -type d -o -type l -o -type f \) \
		-print0 \
| cpio -o -H newc -0 --quiet \
| gzip --fast >"${_outputs}/package.cpio.gz"

if test -n "${_artifacts_cache}" ; then
	cp -T -- "${_outputs}/package.cpio.gz" "${_artifacts_cache}/${_package_name}--${_package_version}.cpio.gz"
fi
## chunk::3b87aa53ffaed5f9c0426a6bbed5704a::end ##

exit 0
