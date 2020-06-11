#!/bin/false

set -o functrace
set -o errtrace
shopt -s expand_aliases
shopt -s extdebug

export STDSH_LOADED=1
if [ -z "$STDSH_PATH" ]
then
    export STDSH_PATH="$1"
fi
declare -A STDSH_LIBRARIES

# Load essential libraries
# General approach is to have libraries assume full environment
# and use fakes and other tricks to bootstrap them

# Temporary fake functions until real ones are defined
alias @args='@macro args'

use ()
{
    :
}

error ()
{
    echo "$@"
    exit 1
}

macroify ()
{
    :
}

# Stripped down version of "use" for required libs
_stdsh_load_library ()
{
    local library="$1" libpath="$STDSH_PATH/lib/${1}.sh"
    STDSH_LIBRARIES["$library"]="$libpath"
    if ! source "$libpath"
    then
        error "Couldn't load library $libpath"
    fi

}


# Load libraries necessary for module
_stdsh_load_library log
_stdsh_load_library meta
_stdsh_load_library error
_stdsh_load_library macro
_stdsh_load_library args

_stdsh_load_library module

# Reload libraries to use real versions of macro, args, and use
_stdsh_load_library log
_stdsh_load_library meta
_stdsh_load_library error
_stdsh_load_library macro
_stdsh_load_library args
