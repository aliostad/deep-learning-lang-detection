$ConfigPath = "$env:appdata\PSPushover\PSPushoverConfiguration.xml"

Function Save-PushoverAPIInformation {
<#
.SYNOPSIS
Used to save a configuration file used for PushOver alerts.
.DESCRIPTION
Used to save a configuration file used for PushOver alerts. It stores the file in the AppData folder
in XML format. 
.EXAMPLE
Save-PushoverAPIInformation -UserKey 'lksjdflhiqhrbrjqbjbrla' -AppToken 'jhsgkbsgkjbbbqbqisksn'
#>
[cmdletbinding()]
param(
    
    [parameter(Mandatory=$True)]
    [ValidateNotNull()]
    [string]$UserKey,
    
    [parameter(Mandatory=$True)]
    [ValidateNotNull()]
    [string]$AppToken

)

    $ReturnObject = New-Object -TypeName psobject -Property @{
        UserKey=$UserKey
        AppToken=$AppToken
    }
    Write-Verbose "Saving Pushover API information to $ConfigPath"
    if (-not (Test-Path (Split-Path $ConfigPath))) {
        New-Item -ItemType Directory -Path (Split-Path $ConfigPath) | Out-Null
    }
    $ReturnObject | Export-clixml -Path $ConfigPath

}