#!/bin/bash
## Copy dotfiles to the git repo

DEST=$HOME
DOTFILES_REPO=$HOME/git/dotfiles
GITHUB_REPO="git@github.com:andrix/dotfiles.git"

if [ -d $DOTFILES_REPO ] 
then
    cd $DOTFILES_REPO
    echo "Updating repo ..."
    git pull --rebase
else
    REPOP=$(dirname $DOTFILES_REPO)
    [[ ! -d $REPOP ]] && mkdir -p $REPOP
    cd $REPOP
    echo "First time use, wait while cloning the repo"
    git clone $GITHUB_REPO
fi

echo "Setup of dotfiles from $DOTFILES_REPO to $DEST"
for f in $(ls -I "." -I ".." -I ".git" -a $DOTFILES_REPO); do
    echo "> Copying $f to $DEST"
    cp -r $DOTFILES_REPO/$f $DEST
done
