#Requires -Version 3.0

function Edit-PSSumoLogicAPIConfig
{
<#
.Synopsis
   Edit PSSumoLogicApi Config in Console
.DESCRIPTION
   Read config and edit in the console
.EXAMPLE
   Edit-PSSumoLogicApiConfig
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
        [switch]
        $NoProfile
    )

    if (Test-Path $configPath)
    {
        if ($NoProfile)
        {
            PowerShell_ise.exe -File $configPath
        }
        else
        {
            PowerShell_ise.exe $configPath
        }
    }
    else
    {
        Write-Verbose ("Could not found configuration file '{0}'." -f $configPath)
    }

}
