#
# introspection
#
#   enable execution of internal functions from CLI
#
#  some_big_script int_call NAME args
#
#   will call only NAME() and exit
#
# usage example:
#
# 1. script with two subfunctions f and b
#   f() {
#   }
#   b() {
#   #
#   introspection_call "$*"
#
# 1. script with introspection for internals
#
#   while [ -n "$1" ] ; then
#       maybe_invoke_introspection "$@"
#       shift
#   done
#   will accept following invocation:
#     script --intcall FUNC_NAME args
#   where FUNC_NAME is private script function
#

invoke_introspection()
{
    local function="$1"
    if ! declare -f "$function" > /dev/null ; then
        (
            if [ -n "$function" ] ; then
                echo "$0: invoke_introspection: $function not found"
            fi
            echo "$0: available functions:"
            declare -F | awk '{print "   ",$3}'
        ) >&2
        exit 1
    fi
    shift
    "$function" "$@"
    return $?
}

list_functions()
{
    declare -F | awk '{print $3}'
}

maybe_invoke_introspection()
{
    if [ "$1" == "--int-call" ] ; then
        shift
        invoke_introspection "$@"
        exit $?
    fi
}

variable_exists()
    ## variable_exists NAME
    ##
    ## checks if variable NAME is set and has non-empty
    ## value
    ## (useful for dynamically created variable names)
{
    [ -n "$(variable_get "$1")" ]
}

variable_set()
    ## variable_set NAME VALUE
    ##
    ## sets variable NAME to value VALUE
    ## (useful for dynamically created variable names)
{
    eval "$1='$2'"
}

variable_get()
    ## variable_get NAME
    ##
    ## outputs VALUE of variable NAME
    ## (useful for dynamically created variable names)
{
    eval echo "\$""$1"
}

