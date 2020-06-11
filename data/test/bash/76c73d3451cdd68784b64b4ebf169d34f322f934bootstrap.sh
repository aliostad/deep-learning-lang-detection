# set dotfiles directory
if [ -z "$DOTFILES_DIR" ]; then
    export DOTFILES_DIR=$HOME/dotfiles
fi
SRC_DIR=$DOTFILES_DIR/src

# load env file, shell source file or print not found message
# if ends in .exports then source
function load {
    # return if not a file
    if [[ ! -e "${1}" ]]; then
        echo "File not found. ${1}"
        return
    fi

    # load environment vars if .exports or .env
    if [[ "${1}" = *.env || "${1}" = *.exports ]];then
        \. bashenv "${1}"
    else
        source "${1}"
    fi
}

# list of shared files for sourcing
files=(
    # initialize system profile
    /etc/profile

    # global zsh source files
    $SRC_DIR/load.sh 
)

# load each of the into our current shell
for file in $files
do
    load $file
done

# load default environment files
load $HOME/.env
load $HOME/.path.env

# load personal files
if [ -d $PERSONAL_DIR ]; then
    for file in `ls $PERSONAL_DIR/src`
    do
        load $PERSONAL_DIR/src/$file
    done
fi

# load in default env / exports file if set
if [[ ! -z "$EXPORTS_FILE" && -f $EXPORTS_FILE ]]
then
    load $EXPORTS_FILE
fi

load $HOME/.personal.env
load $HOME/.temp.env
load $HOME/.temp.sh
