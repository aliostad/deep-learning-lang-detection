#!/bin/sh

backupRepoPath=$1
fileToBackup=$2
repoBackupPath="$backupRepoPath/$fileToBackup"
repoBackupDirectoryPath=${repoBackupPath%/*}

# Store the current directory
currentDirectory=`pwd`

# Make sure the backup location exists
if [ ! -d $backupRepoPath ]; then
	mkdir -p $backupRepoPath
	cd $backupRepoPath
	git init
fi

cd $backupRepoPath

# Make sure the path in the backup directory exist
if [ ! -d $repoBackupDirectoryPath ]; then
	mkdir -p $repoBackupDirectoryPath
fi

# Copy to the working directory
cp $fileToBackup $repoBackupPath

# Add to repo and commit
git add $repoBackupPath
git commit -m "Backup - `date`"

# Back to original directory
cd $currentDirectory
