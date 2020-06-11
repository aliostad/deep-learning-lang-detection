#
# Lazy Load to speed up zsh start
#
# Authors:
#   xcv58 <i@xcv58.com>
#

function lazy_load() {
    local load_func=${1}
    local lazy_func="lazy_${load_func}"

    shift
    for i in ${@}; do
        alias ${i}="${lazy_func} ${i}"
    done

    eval "
    function ${lazy_func}() {
        unset -f ${lazy_func}
        lazy_load_clean $@
        eval ${load_func}
        unset -f ${load_func}
        eval \$@
    }
    "
}

function lazy_load_clean() {
    for i in ${@}; do
        unalias ${i}
    done
}
