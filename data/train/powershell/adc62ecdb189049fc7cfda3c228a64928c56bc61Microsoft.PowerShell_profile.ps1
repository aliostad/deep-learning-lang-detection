$global:CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
function prompt
{
    $wintitle = $CurrentUser.Name + " " + $Host.Name + " " + $Host.Version
    $host.ui.rawui.WindowTitle = $wintitle
    Write-Host ("PS " + $(get-location) +">") -nonewline -foregroundcolor Magenta 
    return " "
}

Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100

[System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SqlServer.Smo”)
[System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SqlServer.SmoExtended”)