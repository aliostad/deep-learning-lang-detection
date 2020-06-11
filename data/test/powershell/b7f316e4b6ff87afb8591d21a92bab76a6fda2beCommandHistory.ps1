$commandHistoryPath = Join-Path (Split-Path -Parent $profile) '.pscommandhistory'
if(Test-Path $commandHistoryPath) { Load-PSCommandHistory }
Register-EngineEvent PowerShell.Exiting -Action { Export-PSCommandHistory } | Out-Null

<#
.SYNOPSIS Loads previous command history, if it exists.
.LINK Export-PSCommandHistory
#>
function Load-PSCommandHistory([string]$path = $commandHistoryPath) {
    if(Test-Path $path) {
        $itemsAdded = 0
        Import-Clixml $path | ?{ $itemsAdded++; $true } | Add-History
        Write-Host ('Loaded {0} history item(s).' -f $itemsAdded) -f $promptTheme.bannerColor
    }
}

<#
.SYNOPSIS Saves the last 100 history items to file.
.LINK Load-PSCommandHistory
#>
function Export-PSCommandHistory([string]$path = $commandHistoryPath) {
    Get-History -Count 100 | Export-Clixml $path
}