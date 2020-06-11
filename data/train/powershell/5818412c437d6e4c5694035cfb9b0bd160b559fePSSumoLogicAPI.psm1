#Requires -Version 3.0

Write-Verbose "Loading PSSumoLogicAPI.psm1"

# PSSumoLogicAPI
#
# Copyright (c) 2013 guitarrapc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


#-- Public Loading Module Custom Configuration Functions --#

function Import-PSSumoLogicAPIConfiguration
{

    [CmdletBinding()]
    param
    (
        [string]
        $PSSumoLogicApiConfigFilePath = (Join-Path $PSSumoLogicApi.defaultconfiguration.dir $PSSumoLogicApi.defaultconfiguration.file)
    )

    if (Test-Path $PSSumoLogicApiConfigFilePath -pathType Leaf) 
    {
        try 
        {        
            Write-Verbose "Load Current Configuration or Default."
            . $PSSumoLogicApiConfigFilePath
        } 
        catch 
        {
            throw ('Error Loading Configuration from {0}: ' -f $PSSumoLogicApi.defaultconfiguration.file) + $_
        }
    }
}

#-- Private TimeZoneChecking function --#
function Check-PSSumoLogicTimeZone
{
    [CmdletBinding()]
    param
    (
    [parameter(
        mandatory = 1,
        position  = 0)]
    [validateSet(
        "Etc/GMT-12",
        "Etc/GMT-11",
        "Pacific/Midway",
        "America/Adak",
        "America/Anchorage",
        "Pacific/Gambier",
        "America/Dawson_Creek",
        "America/Ensenada",
        "America/Los_Angeles",
        "America/Chihuahua",
        "America/Denver",
        "America/Belize",
        "America/Cancun",
        "America/Chicago",
        "Chile/EasterIsland",
        "America/Bogota",
        "America/Havana",
        "America/New_York",
        "America/Caracas",
        "America/Campo_Grande",
        "America/Glace_Bay",
        "America/Goose_Bay",
        "America/Santiago",
        "America/La_Paz",
        "America/Argentina/Buenos_Aires",
        "America/Montevideo",
        "America/Araguaina",
        "America/Godthab",
        "America/Miquelon",
        "America/Sao_Paulo",
        "America/St_Johns",
        "America/Noronha",
        "Atlantic/Cape_Verde",
        "Europe/Belfast",
        "Africa/Abidjan",
        "Europe/Dublin",
        "Europe/Lisbon",
        "Europe/London",
        "UTC",
        "Africa/Algiers",
        "Africa/Windhoek",
        "Atlantic/Azores",
        "Atlantic/Stanley",
        "Europe/Amsterdam",
        "Europe/Belgrade",
        "Europe/Brussels",
        "Africa/Cairo",
        "Africa/Blantyre",
        "Asia/Beirut",
        "Asia/Damascus",
        "Asia/Gaza",
        "Asia/Jerusalem",
        "Africa/Addis_Ababa",
        "Asia/Riyadh89",
        "Europe/Minsk",
        "Asia/Tehran",
        "Asia/Dubai",
        "Asia/Yerevan",
        "Europe/Moscow",
        "Asia/Kabul",
        "Asia/Tashkent",
        "Asia/Kolkata",
        "Asia/Katmandu",
        "Asia/Dhaka",
        "Asia/Yekaterinburg",
        "Asia/Rangoon",
        "Asia/Bangkok",
        "Asia/Novosibirsk",
        "Etc/GMT+8",
        "Asia/Hong_Kong",
        "Asia/Krasnoyarsk",
        "Australia/Perth",
        "Australia/Eucla",
        "Asia/Irkutsk",
        "Asia/Seoul",
        "Asia/Tokyo",
        "Australia/Adelaide",
        "Australia/Darwin",
        "Pacific/Marquesas",
        "Etc/GMT+10",
        "Australia/Brisbane",
        "Australia/Hobart",
        "Asia/Yakutsk",
        "Australia/Lord_Howe",
        "Asia/Vladivostok",
        "Pacific/Norfolk",
        "Etc/GMT+12",
        "Asia/Anadyr",
        "Asia/Magadan",
        "Pacific/Auckland",
        "Pacific/Chatham",
        "Pacific/Tongatapu",
        "Pacific/Kiritimati")]
    [string]
    $TimeZone
    )
    return $TimeZone
}

#-- Enum for SumoLogic --#
Add-Type -TypeDefinition @"
    public enum SumoLogicSourceType
    {
        LocalFile             = 0,
        RemoteFile            = 1,
        LocalWindowsEventLog  = 2,
        RemoteWindowsEventLog = 3,
        Syslog                = 4,
        Script                = 5,
        Alert                 = 6,
        AmazonS3              = 7,
        HTTP                  = 8
    }
"@

#-- Enum for CredRead/Write Type --#
Add-Type -TypeDefinition @"
    public enum WindowsCredentialManagerType
    {
        Generic           = 1,
        DomainPassword    = 2,
        DomainCertificate = 3
    }
"@

#-- Private Loading Module Parameters --#

# contains default base configuration, may not be override without version update.
$Script:PSSumoLogicAPI                        = @{}
$PSSumoLogicAPI.name                          = "PSSumoLogicAPI"                                         # contains the Name of Module
$PSSumoLogicAPI.modulePath                    = Split-Path -parent $MyInvocation.MyCommand.Definition
$PSSumoLogicAPI.helpersPath                   = "\functions\*.ps1"                                       # path of functions
$PSSumoLogicAPI.cSharpPath                    = "\cs\"
$PSSumoLogicAPI.context                       = New-Object System.Collections.Stack                      # holds onto the current state of all variables

$PSSumoLogicAPI.originalErrorActionPreference = $ErrorActionPreference
$PSSumoLogicAPI.errorPreference               = "Stop"
$PSSumoLogicAPI.originalDebugPreference       = $DebugPreference
$PSSumoLogicAPI.debugPreference               = "SilentlyContinue"

#-- Fixed parameters for SumoLogic Service --#

# config
$PSSumoLogicAPI.defaultconfiguration = @{
    dir       = Join-Path $PSSumoLogicAPI.modulePath "\config"
    file      = "PSSumoLogicAPI-config.ps1"                      # default configuration file name within PSSumoLogicAPI.psm1
}
# content type
$PSSumoLogicAPI.contentType        = "application/json"

# uri
$PSSumoLogicAPI.uri = @{
    scheme                         = [string]"https"
    collector                      = [uri]"api.sumologic.com/api/v1/collectors"
    collectorId                    = [uri]"api.sumologic.com/api/v1/collectors/{0}"
    source                         = [uri]"api.sumologic.com/api/v1/collectors/{0}/sources"
    sourceId                       = [uri]"api.sumologic.com/api/v1/collectors/{0}/sources/{1}"
}

#-- Public Loading Module Parameters (Recommend to use ($PSSumoLogicAPI.defaultconfigurationfile) for customization) --#

# credential
$PSSumoLogicAPI.credential = @{
    user                           = "INPUT YOUR Email Address to logon"
}

# Project Name for SumoLogic Source Explanation
$PSSumoLogicAPI.Project = "INPUT PROJECT NAME for source explanation"

$PSSumoLogicAPI.sourceParameter    = @{
    alive                          = [bool]$true
    states                         = [string]""
    automaticDateParsing           = [bool]$true
    timeZone                       = [string](Check-PSSumoLogicTimeZone -TimeZone Asia/Tokyo)
    multilineProcessingEnabled     = [bool]$true
}

# RunSpace Pool size
$PSSumoLogicAPI.runSpacePool = @{
    minPoolSize                    = 1
    maxPoolSize                    = ([int]$env:NUMBER_OF_PROCESSORS * 30)
}

# TimeoutSec
$PSSumoLogicAPI.TimeoutSec   = 5

# Session Variables to obtain coockies
$PSSumoLogicAPI.WebSession   = [Microsoft.PowerShell.Commands.WebRequestSession]@{
    Headers                        = New-Object 'System.Collections.Generic.Dictionary[string,string]'
    Cookies                        = New-Object System.Net.CookieContainer
    UseDefaultCredentials          = $false
    Credentials                    = New-Object System.Net.NetworkCredential
    Certificates                   = New-Object System.Security.Cryptography.X509Certificates.X509CertificateCollection
    UserAgent                      = "Mozilla/5.0 (Windows NT; Windows NT 6.2; ja-JP) WindowsPowerShell/4.0"
    Proxy                          = New-Object System.Net.WebProxy
    MaximumRedirection             = -1
}

# -- Export Modules when loading this module -- #
Get-ChildItem -Path (Join-Path $PSSumoLogicAPI.modulePath $PSSumoLogicAPI.helpersPath) -Recurse `
| where { -not ($_.FullName.Contains('.Tests.')) } `
| where Extension -eq '.ps1' `
| % {. $_.FullName}

# -- Import Default configuration file -- #
Import-PSSumoLogicAPIConfiguration

#-- Export Modules when loading this module --#

Export-ModuleMember `
    -Cmdlet * `
    -Function * `
    -Variable * `
    -Alias *