#!/bin/sh


dir=$(for i in $HOME/roots/ben.devdata/* ; do  [ -d "$i/repos" ] && echo $i ; done | $HOME/local/bin/fzf)

echo "Name of the repo"

read repo
echo  $dir/repos/$repo 

[ -n "$repo" ] || { 
    echo "Err: no repo given. Press key ..." ; 
    read k ; 
    exit ; 
} 

rr=${repo%.*}
r=${rr%.*}


if [ -d $dir/repos/$repo ] ; then 
    echo "Err: Repo already exist"
    echo "Press kye"
    read key
    exit 
else
    mkdir -p $dir/repos/$repo/$r 
    rm -f $HOME/dev/repos/$repo
    ln -s $dir/repos/$repo $HOME/dev/repos/
    echo "OK link in $HOME/dev/repos/$repo"
    echo "Press kye"
    read key
    exit 
fi
