#!/bin/bash


export WORKDIR=${GHA_WORKDIR:?"Need to set GHA_WORKDIR to writeable directory"}

if [[ ! -d "${WORKDIR}" || ! -w "${WORKDIR}" ]] ; then
  echo "${WORKDIR} is not writable.   Please check value of GHA_WORKDIR"
  exit 0
fi

if [ $# -ne 4 ] ; then
   echo "Usage: populateRepo.sh repoName repoURL protoDir" ; 
   echo "Example: populateRepo.sh lab00_Phillip git@github.com:UCSB-CS56-S13/lab00_Phillip.git /cs/faculty/pconrad/cs56/lab00_prototype /cs/faculty/pconrad/cs56/scratchRepos" ; exit 0 
fi

export repoName=$1
export repoURL=$2
export protoDir=$3
export scratchDir=${WORKDIR}/scratch

printf "Populating repo %s... " $repoName 
 #   " with url " $repoURL  \
 #   " from dir " $protoDir \
 #   " in scratch dir " $scratchDir

mkdir -p $scratchDir; cd $scratchDir

if [ -d $scratchDir/$repoName ] ; then
   printf " found repo %s ... " $repoName
else
    printf " cloning repo %s... \n" $repoName
    git clone -q -n $repoURL 
fi

cd $repoName
export cdStatus=$?
if [ $cdStatus -ne 0 ] ; then
    echo "Can't find repo $repoName -- bailing out "; exit 1
fi

git pull 

rm -rvf *

cp -vr $protoDir/* .
git add .
git add -f lib/*


if [ -f $protoDir/.gitignore ] ; then
   cp -v $protoDir/.gitignore .
   git add .gitignore
fi
if [ -f $protoDir/.gitmodues ] ; then
   cp -v $protoDir/.gitmodules .
   git add .gitmodules
fi

git commit -m "Files pushed by populateRepo.sh script"
git push origin master
