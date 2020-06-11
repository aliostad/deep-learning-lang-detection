function Show-WindowsCredentialVaultConfig
{
<#
.Synopsis
   Read WindowsCredentialVault current config and show Config in Console
.DESCRIPTION
   Read config and show it on console.
.EXAMPLE
   Show-WindowsCredentialVaultConfig
#>

    [OutputType([System.String[]])]
    [CmdletBinding()]
    param
    (
        [parameter(mandatory = 0, position = 0)]
        [System.String]$configPath = (Join-Path $WindowsCredentialVault.appdataconfig.root $WindowsCredentialVault.appdataconfig.file),

        [parameter(mandatory = 0, position = 1)]
        [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]$encoding = $WindowsCredentialVault.fileEncode
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
