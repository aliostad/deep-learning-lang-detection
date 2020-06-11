#!/bin/bash
source "$(dirname "$0")/bs.sh"

INFO "Checking VCSH repositories"
REPOS="bash emacs gdb git gtk pkgs secret xconfig xmonad"
DOASKPULL=0
for repo in $REPOS ; do
    if vcsh status $repo >/dev/null 2>&1 ; then
        if [ $DOASKPULL -eq 0 ] ; then
            if promptyn "Do \`pull' for existing repositories?" "y" ; then
                DOPULL=0
            else
                DOPULL=1
            fi
            DOASKPULL=1
        fi
        OK $repo
        if [ $DOPULL -eq 0 ] ; then
            vcsh $repo pull
        fi
    else
        INFO Cloning $repo
        vcsh init $repo
        vcsh $repo remote add origin git@github.com:br0ns/vcsh-$repo.git
        vcsh $repo fetch origin master
        vcsh $repo reset --hard origin/master
    fi
    assert [ -d ".config/vcsh/repo.d/$repo.git" ]
done
