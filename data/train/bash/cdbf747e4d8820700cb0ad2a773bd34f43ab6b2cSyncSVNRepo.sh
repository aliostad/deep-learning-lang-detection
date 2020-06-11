#!/bin/sh

# SyncSVNRepo.sh : get all the content of a remote SVN repo and dump all
#		the content a local SVN repo
# $1 : Local repo name
# $2 : Remote repo url
# Author : lehoangminh@live.com

if test -z $1 
then
   echo "Please input local repo name"
   exit 1
fi

if test -z $2 
then
   echo "Please input remote repo url"
   exit 1
fi

repoName=$1
externalPath=$2
svnadmin create $repoName
cd ./$repoName
mv ./hooks/pre-revprop-change.tmpl ./hooks/pre-revprop-change
echo "#!/bin/sh" > ./hooks/pre-revprop-change
echo "exit 0;" >> ./hooks/pre-revprop-change
chmod +x ./hooks/pre-revprop-change
svnsync init file:///`pwd` $externalPath
svnsync sync file:///`pwd`
svnadmin dump `pwd` > ../${repoName}.dump
cd ../
rm -rf $repoName
svnadmin create $repoName
svnadmin load `pwd`/$repoName < ${repoName}.dump
rm ${repoName}.dump
