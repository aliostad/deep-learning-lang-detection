
# Load posh-git example profile
. (Resolve-Path ~\Documents\WindowsPowershell\Modules\posh-git\profile.example.ps1)

# Load posh-hg example profile
# . '.\Modules\posh-hg\profile.example.ps1'
. (Resolve-Path ~\Documents\WindowsPowershell\Modules\posh-hg\profile.example.ps1)

Import-Module PSReadLine
Import-Module z
Import-Module PsHosts

# Overriding the prompt with one from posh-git
function global:prompt {

    Write-Host('PS ') -nonewline 

    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-Host
    Write-Host('$') -nonewline

    return " "
}
