#!/bin/bash

# Lets you put a .profile in any directory. If bash starts in that directory
# (for example, because you opened a new window in tmux), and it has a
# `.profile` in it.
readonly AUTOLOAD_PROFILE_FILENAME=".profile"
readonly AUTOLOAD_PROFILE_STRING='# autoload'
load_profile()
{
    if [[ "$(pwd)" != "$HOME" && -e "$AUTOLOAD_PROFILE_FILENAME" ]]; then
        local ok_to_load
        ok_to_load=$(head -1 "$AUTOLOAD_PROFILE_FILENAME")
        if [[ "$ok_to_load" == "$AUTOLOAD_PROFILE_STRING" ]]; then
            echo "$(tput setaf 3)$(tput bold)Notice:$(tput sgr0) Loading profile..."
            source "$AUTOLOAD_PROFILE_FILENAME"
        else
            echo "$(tput setaf 1)$(tput bold)Warning:$(tput sgr0) profile in this directory exists but is not safe to load."
        fi
    fi
}
load_profile
