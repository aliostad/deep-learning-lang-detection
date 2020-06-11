#!/usr/bin/env bash

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.bzr' ]]; then
			if [[ "$(echo "${PWD}" | grep '.git/bzr')" ]]; then
				true
			else
				echo
				echo "BZR - ${PWD}"
				echo
				
				bzr upgrade --default
				echo
			fi
		elif [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" != '.' ]] && [[ "${_repo}" != '..' ]] && [[ "${_repo}" != 'lost+found' ]] && [[ ! "$(file "${PWD}/${_repo}" | grep 'symbolic link to')" ]]; then
			pushd "${_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
	done
}

_RUN
