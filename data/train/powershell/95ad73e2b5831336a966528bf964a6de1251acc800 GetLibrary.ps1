<#
    If you would like to have access to the full AD library I have written
    please set $Global:LoadLibFromURL = $true.
    
    Otherwise this updated file will dot-source the stub library that
    has only the functions required for the plug-in to work.
#>
$Title = "Library Settings for AD-Plugins"
$Comments = "Define how to grab functions"
$Display = "List"
$Author = "Jeff Patton"
$PluginVersion = 1

$Global:LoadLibFromURL = $false

if ($LoadLibFromURL -eq $false)
{
    . .\Plugins\ADStubLibrary.ps1
    }
else
{
    $LibFile = (Join-Path $pwd "ActiveDirectoryManagement.ps1")
    $LibURL = "http://mod-posh.googlecode.com/svn/powershell/production/includes/ActiveDirectoryManagement.ps1"
    $webclient = New-Object Net.Webclient
    $webClient.UseDefaultCredentials = $true
    $webClient.DownloadFile($LibURL, $LibFile)
    . $LibFile
    }