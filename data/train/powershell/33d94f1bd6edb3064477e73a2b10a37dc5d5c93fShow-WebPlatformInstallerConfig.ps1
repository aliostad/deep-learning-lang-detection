#Requires -Version 3.0

<#
.Synopsis
   Show Config in Console
.DESCRIPTION
   Read config and show in the console
.EXAMPLE
   Show-WebPlatformInstallerConfig
#>
function Show-WebPlatformInstallerConfig
{
    [CmdletBinding()]
    param
    (
        [parameter(mandatory = 0, position = 0)]
        [string]$configPath = (Join-Path $WebPlatformInstaller.appdataconfig.root $WebPlatformInstaller.appdataconfig.file),

        [parameter(mandatory = 0, position = 1)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]$encoding = "default"
    )

    if (Test-Path $configPath)
    {
        Get-Content -Path $configPath -Encoding $encoding
    }
    else
    {
        Write-Verbose ("Could not found configuration file '{0}'." -f $configPath)
    }
}
