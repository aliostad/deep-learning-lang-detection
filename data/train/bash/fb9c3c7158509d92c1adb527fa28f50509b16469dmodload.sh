_dmods=()

function dmodload() {
    case "${_dmods[@]}" in *"$1"*) return ;; esac
    _dmods+="$1"

    local module_load_path="$DOTFILES_PATH/modules/$1"

    if [[ ! -d "$module_load_path" ]]; then
        >&2 echo "Module not found: $1"
    fi

    if [[ -f "$module_load_path/condition.sh" ]]; then
        if ! source "$module_load_path/condition.sh"; then
            return
        fi
    fi

    dload "$module_load_path/preinit"
    dload "$module_load_path/init"
    dload "$module_load_path/postinit"
}
