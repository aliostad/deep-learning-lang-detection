autoload colors
colors

# Load a config file named $1, and if a $1_local files exists load that too
config_load () {
    if [ -e "$1" ]; then
        echo "  ${fg_bold[green]}loading    ${fg_no_bold[default]} $1"
        source "$1"
        if [ -e "$1_local" ]; then
            echo "  ${fg_bold[green]}loading    ${fg_no_bold[default]} $1_local"
            source "$1_local"
        fi
    else
        echo "  ${fg_bold[red]}cannot load${fg_no_bold[default]} $1"
    fi
}

config_zshscripts() {
	if [ -n "$1" ]; then
		for file in $*; do
			config_load functions/$file.zsh
		done
	else
		for file in functions/*.zsh; do
			config_load $file
		done
	fi
}
