#!/usr/bin/env bash

_LAUNCHPAD_USER="the-ridikulus-rat"

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.bzr' ]]; then
			if [[ $(echo "${PWD}" | grep '.git/bzr') ]]; then
				true
			else
				if [[ "$(cat "${PWD}/${_repo}/branch/branch.conf" | grep 'parent_location = ')" ]]; then
					echo
					echo "BZR - ${PWD}"
					echo
					
					bzr lp-login "${_LAUNCHPAD_USER}"
					echo
					
					bzr pull
					echo
				fi
			fi
		elif [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" != '.' ]] && [[ "${_repo}" != '..' ]] && [[ "${_repo}" != 'lost+found' ]] && [[ ! "$(file "${PWD}/${_repo}" | grep 'symbolic link to')" ]]; then
			pushd "${_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
	done
}

bzr lp-login "${_LAUNCHPAD_USER}"

_RUN

unset _LAUNCHPAD_USER
