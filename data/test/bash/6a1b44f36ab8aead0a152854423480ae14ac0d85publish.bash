#!/dev/null
## chunk::c09758c19d066c51783e8ac62a9ae225::begin ##

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

## chunk::d63e3622fd5d8efb682c6cb0faffe808::begin ##
if test "${pallur_publish_cp:-false}" == true ; then
	test -n "${pallur_publish_cp_store}"
	pallur_publish_cp_target="${pallur_publish_cp_store}/${_package_name}/${_package_version}/package.cpio.gz"
	echo "[ii] publishing via \`cp\` method to \`${pallur_publish_cp_target}\`..." >&2
	if test ! -e "$( dirname -- "${pallur_publish_cp_target}" )" ; then
		mkdir -p -- "$( dirname -- "${pallur_publish_cp_target}" )"
	fi
	cp -T -- "${_outputs}/package.cpio.gz" "${pallur_publish_cp_target}"
fi
## chunk::d63e3622fd5d8efb682c6cb0faffe808::end ##

## chunk::bb510508f1a2000fc0ddbe7e8a7807d7::begin ##
if test "${pallur_publish_curl:-false}" == true ; then
	test -n "${pallur_publish_curl_credentials}"
	test -n "${pallur_publish_curl_store}"
	pallur_publish_curl_target="${pallur_publish_curl_store}/${_package_name}/${_package_version}/package.cpio.gz"
	echo "[ii] publishing via \`curl\` method to \`${pallur_publish_curl_target}\`..." >&2
	env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_args[@]}" \
			--anyauth --user "${pallur_publish_curl_credentials}" \
			--upload-file "${_outputs}/package.cpio.gz" \
			-- "${pallur_publish_curl_target}"
fi
## chunk::bb510508f1a2000fc0ddbe7e8a7807d7::end ##

exit 0
## chunk::c09758c19d066c51783e8ac62a9ae225::end ##
