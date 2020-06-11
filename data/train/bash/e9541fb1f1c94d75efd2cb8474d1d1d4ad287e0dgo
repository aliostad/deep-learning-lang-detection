#!/bin/bash
REPO_BASE=$HOME/repos

ln -s $REPO_BASE/dot/.vimrc $HOME
ln -s $REPO_BASE/dot/.vim $HOME
ln -s $REPO_BASE/dot/.config $HOME
ln -s $REPO_BASE/dot/.tmux.conf $HOME
ln -s $REPO_BASE/dot/.irssi $HOME
ln -s $REPO_BASE/dot/.Xdefaults $HOME

# SLIM stuff
sudo ln -s $REPO_BASE/dot/slim-debian-simple /usr/share/slim/themes
sudo rm /etc/slim.conf
sudo ln -s $REPO_BASE/dot/slim.conf /etc

# Drop speaker
sudo sh -c 'echo "blacklist pcspkr" >> /etc/modprobe.d/blacklist'

# Bash settings
cat $REPO_BASE/dot/.bashrc >> $HOME/.bashrc

