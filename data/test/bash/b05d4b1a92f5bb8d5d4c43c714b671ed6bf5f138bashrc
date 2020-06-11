#!/bin/bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load global bash profile
[ -r '/etc/profile' ] && source /etc/profile

###############################################################################
# Load external definitions {{{
#

function load_file()
{
    local file="$1"
    if [ -r "$file" ]; then
        echo "loading $file ..."
        source "$file" >/dev/null 2>&1 || true
    fi
}

function reload_env()
{
    local rcdir="$HOME/.bashrc.d"
    for script in $(find -L $rcdir -type f | grep -v '.sw[a-z]$' | sort); do
        load_file $script
    done
}

if [ "$TERM" != "dumb" ]; then
    reload_env
fi

# }}}

################################################################################
# OPAM {{{

load_file "$HOME/.opam/opam-init/init.sh"

# }}}
