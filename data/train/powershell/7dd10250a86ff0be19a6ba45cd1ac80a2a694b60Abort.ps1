###	Deploy.ps1:	Handles deployments of the Beano project to azure, with 
###				support for staging slots, db migrations and git integration


Param(	[Parameter(Mandatory=$True)][string]$env)

$env = $env.ToLower()

# set script directory to location of deploy.ps1 file to allow execution from any directory
$scriptDirectory = Split-Path -parent $MyInvocation.MyCommand.Path

# load in the collection of modules required for script execution
foreach ($module in @("utils","sql", "nuget", "msbuild", "migrator", "git")) {
	Import-Module $scriptDirectory\Modules\$module\$module.psm1 -force -disableNameChecking
}

# set some global vars
$projectName = Get-ProjectSetting "name"
$workingDirectory = Get-WorkingDirectory "$scriptDirectory"
$dbName = Get-SqlSetting "$env" "db-name"


Write-Step "removing staging database"
Remove-Db "$env" "${dbName}_Staging"

Write-Step "you can now safely remove the staging slot for the $projectName project in Azure: https://manage.windowsazure.com"

Write-Step "reset master to last stable tag"
