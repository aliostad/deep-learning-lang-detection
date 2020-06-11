<#
.SYNOPSIS
Save-Processes saves the name and id of the locally running processes at
the given point in time when this script is run to a file on the local computer.
.DESCRIPTION
Save-Processes retrieves the currently runnning processes on the local computer
and saves the process name along with the process id to a file on the local
computer. You must have modify rights to create the file specified in the filename
parameter and to the directories specified in the path parameter. The file is
overwritten if it already exists even if the file is set to read only (the -force
option causes a file set to read only to be overwritten regardless). The specified
path is created if it does not already exist.
.PARAMETER path
The drive letter and path to save the results to. Default: 'c:\2012SG\event3'
.PARAMETER filename
The filename to save the results to. Default: 'process3.txt'
.EXAMPLE
Get-DiskInventory -path 'c:\2012SG\event3' -filename 'process3.txt'
#>
param (
  $path = 'c:\2012SG\event3',
  $filename = 'process3.txt'
)
$ErrorActionPreference = 'stop'
 try {
 if (-not(Test-Path $path -pathType container)) {New-Item -ItemType directory -path $path}
 Get-Process | Select-Object name, id | Out-File $path\$filename -Force
 }
 catch
{
   "The script failed due to: $_"
}