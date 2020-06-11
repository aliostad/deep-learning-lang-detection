
$installDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

if (!$env:HOME) { $env:HOME = "$env:HOMEDRIVE$env:HOMEPATH" }
if (!$env:HOME) { $env:HOME = "$env:USERPROFILE" }
set HOME $env:HOME -Force
(Get-PSProvider 'FileSystem').Home = $env:HOME

. $installDir\shared.ps1

. $installDir\7zip\load.ps1
. $installDir\git\load.ps1
. $installDir\git-tfs\load.ps1
. $installDir\posh-git\load.ps1

. $installDir\colored-ls\load.ps1

if (GitIsInstalled -and PoshGitIsInstalled)
{
     $Global:GitTabSettings.AllCommands = $true
    Start-SshAgent -Quiet
}

cd $env:HOME

if (Test-Path $profile)
{
    . $profile
}

if (Test-Path .\profile.ps1)
{
    . .\profile.ps1
}

Clear-Host
