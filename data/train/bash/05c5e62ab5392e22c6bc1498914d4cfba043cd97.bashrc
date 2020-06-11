#!/bin/bash

HISTSIZE=1000
HISTFILESIZE=2000

function load_rcfile {
    if [ -d $1 ]; then
        for content in `ls $1`; do
            if [ -d $1 ]; then
                load_rcfile $1/$content
            elif [ -f $1 ]; then
                source $1/$content
            fi
        done
    elif [ -f $1 ]; then
        source $1
    fi
}

load_rcfile ~/.bash
load_rcfile ~/.bash_aliases
load_rcfile ~/.bash_exports
load_rcfile ~/.bash_local
load_rcfile ~/.nvm/nvm.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
