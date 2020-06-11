#Load Boxstarter.Chocolatey
Import-Module Boxstarter.Chocolatey

Update-ExecutionPolicy Unrestricted

# Load custom functions .\Common\functions
. .\Common\functions\Install-CommonFunctions.ps1

#Need to exclude Common directory from list
$arr = Get-ChildItem -Path $PSScriptRoot -Directory |  
		? { $_.psiscontainer -and $_.fullname -notmatch 'Common' } | 
       Foreach-Object {$_.Name}

For ($i = 0; $i -le $arr.length-1; $i++){
    Write-Host "[" $i "] " $arr[$i]
}

$projectNo = Read-Host "Please select your project from the list above"
$projectName = $arr[$projectNo]
Write-Host $projectName

# Call the package install file rather than use command directly
# 
#		cinst $projectName\packages.config -y
#
# This will allow Install-Project-Package.ps1 to cater for specific
# project configurations for each project if needed
& $projectName\Install-ProjectPackage.ps1

# Clean up after script
Remove-Module Boxstarter*

# Remove custom functions .\Common\functions
# as there seem to be issues if functions are loaded multiple times
. .\Common\functions\Remove-CommonFunctions.ps1

