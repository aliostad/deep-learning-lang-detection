﻿#Requires -Version 3.0

<#
.Synopsis
   Show Valentia Config in Console
.DESCRIPTION
   Read config and show in the console
.EXAMPLE
   Show-ValentiaConfig
#>
function Show-ValentiaConfig
{
    [OutputType([string[]])]
    [CmdletBinding()]
    param
    (
        [parameter(mandatory = $false, position = 0)]
        [string]$configPath = "",

        [parameter(mandatory = $false, position = 1)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]$encoding = $Valentia.fileEncode
    )

    if (($configPath -eq "") -or (-not (Test-Path $configPath)))
    {
        if (Test-Path (Join-Path $valentia.originalconfig.root $valentia.originalconfig.file))
        {
            $configPath = (Join-Path $valentia.originalconfig.root $valentia.originalconfig.file)
        }
    }

    if (Test-Path $configPath)
    {
        Get-Content -Path $configPath -Encoding $encoding
    }
    else
    {
        ("Could not found configuration file '{0}'." -f $configPath) | Write-ValentiaVerboseDebug
    }
}
