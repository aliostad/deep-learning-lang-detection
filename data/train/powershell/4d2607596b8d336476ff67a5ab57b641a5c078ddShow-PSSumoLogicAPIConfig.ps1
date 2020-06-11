#Requires -Version 3.0

function Show-PSSumoLogicAPIConfig
{
<#
.Synopsis
   Show PSSumoLogicApi Config in Console
.DESCRIPTION
   Read config and show in the console
.EXAMPLE
   Show-PSSumoLogicApiConfig
#>

    param
    (
        [parameter(
            mandatory = 0,
            position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $configPath = (Join-Path $PSSumoLogicApi.defaultconfiguration.dir $PSSumoLogicApi.defaultconfiguration.file),

        [parameter(
            mandatory = 0,
            position = 1)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
        $encoding = 'utf8'
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
