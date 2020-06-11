#!/usr/bin/env bash

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.hg' ]]; then
			if [[ "$(echo "${PWD}" | grep '.git/hgcheckout')" ]]; then
				true
			elif [[ "$(cat "${PWD}/${_repo}/hgrc" | grep 'default = ')" ]]; then
				echo
				echo "HG - ${PWD}"
				echo
				
				hg revert -a --no-backup
				echo
				
				hg revert -r tip --all
				echo
				
				hg pull
				echo
				
				hg update
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
