#!/bin/bash
echo "################################################################################################"
echo "Creating Directories"
mkdir -p ~/bin
mkdir -p ~/AOSP_Galarza
chown galarza ~/bin
chown galarza ~/AOSP_Galarza
cd ~/AOSP_Galarza
PATH=~/bin:$PATH
echo "################################################################################################"
echo "Downloading Repo Tool \"WILL\" take a lot"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo "End of installation 2"
echo "################################################################################################"
