Import-Module PSReadLine

# Load posh-git example profile
. 'C:\Program Files\WindowsPowerShell\Modules\posh-git\0.6.1.20160330\profile.example.ps1'

$powershell = (join-path $env:USERPROFILE dotfiles/powershell)

# Environment Variables
$global:PSDefaultModulePath = $env:PSModulePath
$modulePath = (join-path $powershell Modules)
$env:PSModulePath = $modulePath + ";" + $env:PSModulePath

# Profile Extensions
. (join-path $powershell aliases.ps1)

#################################################
# => Settings
#################################################
Set-PSReadlineOption -EditMode Vi

$GitPromptSettings.EnableFileStatus = $false # no file status in poshgit
