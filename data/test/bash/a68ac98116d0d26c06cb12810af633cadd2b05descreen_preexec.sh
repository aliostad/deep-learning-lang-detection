# Calculate comment=#
#!/bin/bash

# the script used for the automatic changing of screen tab names

if [[ "$SCREEN_RUN_HOST" == "" ]]
then
    SCREEN_RUN_HOST="$LC_SCREEN_RUN_HOST"
    SCREEN_RUN_USER="$LC_SCREEN_RUN_USER"
fi

preexec_interactive_mode=""

function preexec () {
    true
}

function precmd () {
    true
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

    PROMPT_COMMAND="${PROMPT_COMMAND}"$'\n'"preexec_invoke_cmd;";
    trap 'preexec_invoke_exec' DEBUG
}

case ${TERM} in

    screen-256*)

        precmd () {
            echo -ne "\033kbash\033\\" > /dev/stderr
        }
        
        preexec () {
            local CMD=`echo "$BASH_COMMAND"  | cut -d " " -f 1`
            if [[ "$CMD" == "exec" ]] || [[ "$CMD" == "sudo" ]]
            then
                local CMD=`echo "$BASH_COMMAND"  | cut -d " " -f 2`
            fi
            echo -ne "\033k$CMD\033\\" > /dev/stderr
        }
        
        preexec_install

;;

esac

