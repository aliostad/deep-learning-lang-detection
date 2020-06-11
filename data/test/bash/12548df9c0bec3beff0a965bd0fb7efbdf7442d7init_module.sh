

###################  INIT MODULES  ####################################

[[ ! "$PROG_NAME" == '' ]] && LOAD_MODULE_PROG_BASE=${PROG_NAME}
[[ ! "$MOD_NAME" == '' ]] && LOAD_MODULE_PROG_BASE=${MOD_NAME-$LOAD_MODULE_PROG_BASE}
[[ "$LOAD_MODULE_PROG_BASE" == '' ]] && echo 'ERROR: UNDEFINED PROG_NAME OR MOD_NAME' && exit 1
eval "${LOAD_MODULE_PROG_BASE}_REQ_MODS=( \\${REQUEST_MODS[@]} )"
eval "${LOAD_MODULE_PROG_BASE}_MOD_NAME='${LOAD_MODULE_PROG_BASE}'"


LOAD_FUNCTION_STRING=`cat <<EOF

function ${LOAD_MODULE_PROG_BASE}_LOAD_FUNCTION {

    eval "local CURRENT_MOD_NAME=\\${${LOAD_MODULE_PROG_BASE}_MOD_NAME}"
    eval "local CURRENT_MOD_REQ_MODS=(\\${${LOAD_MODULE_PROG_BASE}_REQ_MODS[@]})"
    if [ -n \\$HAVE_LOADED_MODS ];then
        HAVE_LOADED_MODS=(\\${HAVE_LOADED_MODS[@]})
    fi
    local l_mod
    local h_mod
    local shell_modules_dir=\\${MODS_DIR-'/data/scripts/lib/shell_modules'}
    local is_load=0
    for l_mod in \\${CURRENT_MOD_REQ_MODS[@]}
    do
        is_load=0
        for h_mod in \\${HAVE_LOADED_MODS[@]}
        do
            if [ \\$l_mod == \\$h_mod ];then
                is_load=1
                break
            fi
        done

        if [ \\$is_load -eq 1 ];then
            continue
        fi
        if [ -f \\${shell_modules_dir}/\\${l_mod}.sh ];then
            source \\${shell_modules_dir}/\\${l_mod}.sh
        else
            echo "\\$0 LOAD MODULE[\\${l_mod}] ERROR !"
            echo "The module[\\${l_mod}] not exist DIR[\\${shell_modules_dir}]!"
            exit 1
        fi
        if [ \\$? -eq 0 ];then
            HAVE_LOADED_MODS=(\\${HAVE_LOADED_MODS[@]}  \\$l_mod)
        else
            echo "\\$0 LOAD MODULE[\\${l_mod}] ERROR !"
            exit 1
        fi
    done

}
EOF
`
eval "$LOAD_FUNCTION_STRING"
${LOAD_MODULE_PROG_BASE}_LOAD_FUNCTION
##################################################################