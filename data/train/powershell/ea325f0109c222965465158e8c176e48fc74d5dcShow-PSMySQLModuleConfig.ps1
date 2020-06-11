#Requires -Version 3.0

function Show-PSMySQLModuleConfig
{
<#
.Synopsis
   Show PSMySQLModule Config in Console
.DESCRIPTION
   Read config and show in the console
.EXAMPLE
   Show-PSMySQLModuleConfig
#>

    param
    (
        [parameter(
            mandatory = 0,
            position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $configPath = (Join-Path $PSMySQLModule.modulePath $PSMySQLModule.defaultconfigurationfile),

        [parameter(
            mandatory = 0,
            position = 1)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Ascii", "BigEndianUnicode", "Byte", "Default","Oem", "String", "Unicode", "Unknown", "UTF32", "UTF7", "UTF8")]
        [string]
        $encoding = "default"
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
