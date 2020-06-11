#!/bin/sh

# set -e
set -x

cd /scr/tmp/$USER

# svnrepo=file:///scr/tmp/maclean/svn_mirror/eol_svn_repo/common/trunk/site_scons
svnrepo=http://svn.eol.ucar.edu/svn/eol/common/trunk/site_scons

repo=eol_scons_git
rm -rf $repo

mkdir $repo
cd $repo

{
    git svn init --prefix=svn/ $svnrepo

    git config --local --get user.name
    git config --local svn.authorsfile ~maclean/.svn2git/authors
    git svn fetch -r 5888:HEAD

    git branch -l --no-color
    git branch -r --no-color

    git branch --track "git-svn" "remotes/svn/git-svn"
    git checkout -b "git-svn" "remotes/svn/git-svn"

    git config --local --get user.name
    git config --local --get user.email
    git checkout -f master

    git svn create-ignore

    git gc

} >& ../$repo.log

cd ..

# create bare repo to send to github
bare_repo=${repo%_*}.git
rm -rf $bare_repo
git clone --bare $repo $bare_repo

