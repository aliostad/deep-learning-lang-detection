#!/bin/env bash

GIT_REPO=$1    ; [ -z "$GIT_REPO"    ] && echo "Specifica la directory di inizializzazione..." && exit 1
GIT_COMMENT=$2 ; [ -z "$GIT_COMMENT" ] && GIT_COMMENT="Initial commit repo '$GIT_REPO'."

DIR_REPO=$(cd "$GIT_REPO" && pwd)

################################################################################

#git init $GIT_REPO

################################################################################
 [ "$(pwd)" != "$DIR_REPO" ] && cd $DIR_REPO
#-------------------------------------------------------------------------------

#git config --global user.name   'Carlo "zappyk" Zappacosta'
#git config --global user.email  zappyk@gmail.com
#git config --global core.editor vim
#git config --global merge.tool  vimdiff

#-------------------------------------------------------------------------------

#git config --list

################################################################################
 [ "$(pwd)" != "$DIR_REPO" ] && cd $DIR_REPO
#-------------------------------------------------------------------------------

#git add *

#git status

################################################################################
 [ "$(pwd)" != "$DIR_REPO" ] && cd $DIR_REPO
#-------------------------------------------------------------------------------

#git commit -m "$GIT_COMMENT" *

################################################################################

exit
