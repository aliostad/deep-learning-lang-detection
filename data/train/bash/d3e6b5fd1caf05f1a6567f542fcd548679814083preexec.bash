#!/bin/bash

preexec_interactive_mode=""

preexec() {
	local commandstring=$1;
	if [[ $commandstring != "" ]]; then
		preexec_screen_title "[${USER}@${HOSTNAME}:${PWD/#${HOME}/~}]\$ $1";
	fi
}

precmd() {
	return
}

function preexec_invoke_cmd () {
    precmd
    preexec_interactive_mode="yes"
}

function preexec_invoke_exec () {
    if [[ -n "$COMP_LINE" ]]
    then
        return
    fi
    if [[ -z "$preexec_interactive_mode" ]]
    then
        return
    else
        if [[ 0 -eq "$BASH_SUBSHELL" ]]
        then
            preexec_interactive_mode=""
        fi
    fi
    if [[ "preexec_invoke_cmd" == "$BASH_COMMAND" ]]
    then
        preexec_interactive_mode=""
        return
    fi

    local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
    preexec "$this_command"
}

function preexec_install () {
    set -o functrace > /dev/null 2>&1
    shopt -s extdebug > /dev/null 2>&1

    # Finally, install the actual traps.
	export PROMPT_COMMAND="preexec_invoke_cmd"
    trap 'preexec_invoke_exec' DEBUG
}

function preexec_screen_title () {

    local title="$1"

	if test -z "$PS1"; then
		return
	fi

	case "${TERM}" in

		"screen")
		echo -ne "\033k$1\033\\" > /dev/stderr
		;;

		"linux")
		# do nothing
		;;

		*)
		echo -ne "\033]0;$1\007"
		;;

	esac

}
