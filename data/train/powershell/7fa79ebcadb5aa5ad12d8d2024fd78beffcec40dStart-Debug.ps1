
<#
This script will run on debug.
It will load in a PowerShell command shell and import the module developed in the project. To end debug, exit this shell.
#>

# Write a reminder on how to end debugging.
$message = "| Exit this shell to end the debug session! |"
$line = "-" * $message.Length
$color = "Cyan"
Write-Host -ForegroundColor $color $line
Write-Host -ForegroundColor $color $message
Write-Host -ForegroundColor $color $line
Write-Host 

# Load the module.
#$env:PSModulePath = ".;$env:PSModulePath"
$env:PSModulePath = (Resolve-Path .).Path + ";" + $env:PSModulePath
Import-Module GoogleStorage 

cd ..\..\

#Grant-GoogleStorageAuth -ShowBrowser -Persist

#Get-GoogleStorageConfig
#Get-GoogleStorageBucket -bucket uspto-pair -NoAuth -ListContents | out-host -paging
#Get-GoogleStorageBuckets -Project direct-link-612 
#debug-stuff
#export-googlestoragebucket uspto-pair d:\storage -noauth -force -verbose -includemetadata

# Happy debugging :-)

