# A script to load posh-git and github modules to PowerShell on-demand
# Use the alias "git" to load modules. After, git will be un-aliased its original git.exe form.
# This has sped up my launch time of a shell by ~5 seconds each time


# Note: add this line to your PowerShell profile, ie. "~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
# 
# New-Item alias:git -value "~\Documents\WindowsPowerShell\loadGit.ps1"
#

Remove-Item alias:git

# Load git
. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")

# Load posh-git example profile
. '~\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'
$env:github_posh_git = "~\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1"
