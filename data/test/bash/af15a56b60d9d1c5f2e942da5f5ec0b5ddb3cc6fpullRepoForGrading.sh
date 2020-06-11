#!/bin/bash

# Author: Phillip Conrad

if [ $# -ne 3 ] ; then
   echo "Usage: pullRepoForGrading.sh repoName repoURL gradingDir" ; 
   echo "Example: pullRepoForGrading.sh lab00_Phill git@github.com:UCSD-CSE-100/lab00_Phillip.git /cs/faculty/pconrad/cs56/labSubmissions/lab00" ; exit 0 
fi

export repoName=$1
export repoURL=$2
export gradingDir=$3

mkdir -p $gradingDir; cd $gradingDir

if [ -d $gradingDir/$repoName ] ; then
   printf " found repo %s ... doing git pull ...\n" $repoName
   cd $gradingDir/$repoName
   git pull
else
   printf " cloning repo %s... \n" $repoName
   git clone $repoURL 
fi
