#!/bin/bash

cfgCourseName="BIF/SWE1"
cfgRepoName="BIF-WS$(date +%y)-SWE1"
cfgRepoTestPattern="BIF-WS[0-9][0-9]-SWE1$"
cfgTempateUrl="https://inf-swe-git.technikum-wien.at/r/BIF/SWE1-Java.git"

repoName=$1

echo "============================================"
echo "Cloning $cfgCourseName template"
echo "============================================"

while [  -z $repoName ]; do
	echo ""
    echo "Name of the git-repository. Name must include the current year."
	echo "Example: $cfgRepoName"
    echo -n "RepoName (ENTER for $cfgRepoName): "
    read repoName
	
	if [ -z $repoName ]; then 
		repoName=$cfgRepoName
	fi

	if [[ ! $repoName =~ $cfgRepoTestPattern ]]; then
		echo "** ERROR: Parameter is not in a valid format!"
		repoName=""
	fi
done

echo ""

git clone $cfgTempateUrl "$repoName"
cd "$repoName"
chmod +x *.sh

echo ""
./setup-remotes.sh "$repoName"
