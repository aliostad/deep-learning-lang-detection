#!/usr/bin/env bash

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.git' ]]; then
			echo
			echo "${PWD}"
			echo
			
			sed 's|name = Keshav Padmini Rammohan|name = Keshav Padram Amburay|g' -i "${PWD}/${_repo}/config"
			
			echo
		elif [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" != '.' ]] && [[ "${_repo}" != '..' ]] && [[ "${_repo}" != 'lost+found' ]] && [[ ! "$(file "${PWD}/${_repo}" | grep 'symbolic link to')" ]]; then
			pushd "${_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
	done
}

_RUN
