# CreateSvnStruct v1.00
# Copyright © 2008 by James Kovacs
# All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
# ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND/OR FITNESS FOR A
# PARTICULAR PURPOSE.

# Check usage
If($args.Length -ne 1) {
  Write-Host "Usage: .\CreateSvnRepo.ps1 <RepoUrl>"
  Write-Host "  where RepoUrl is the base url for your repository"
  Write-Host "        in which trunk, tags, and branches will be created."
  Write-Host "N.B. RepoName cannot accept a file path."
  Write-Host "     CreateSvnRepo assumes that svn is in your path."
  Exit(0)
}

# Set up variables needed by script
$repoUrl = $args[0]
$tempPath = [System.IO.Path]::GetTempPath()
$tempDirName = [System.IO.Path]::GetRandomFileName()
$workingCopy = Join-Path $tempPath $tempDirName
$dirNames = 'branches', 'tags', 'trunk'

# Create a temporary working copy so we can commit initial setup in one go
Write-Host "Creating temporary working copy in $workingCopy"
New-Item -path $tempPath -name $tempDirName -type directory
svn checkout --non-interactive $repoUrl $workingCopy

Write-Host "Creating directories in working copy"
ForEach ($dirName in $dirNames) {
  $path = Join-Path $workingCopy $dirName
  svn mkdir $path
}

# Commit changes to the repository
Write-Host "Committing changes"
svn commit $workingCopy --message "Initial repository setup"

# Perform cleanup
Write-Host "Cleaning up working copy"
Remove-Item -path $workingCopy -recurse -force