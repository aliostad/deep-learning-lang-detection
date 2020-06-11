<#
.SYNOPSIS
    Save a URLs HTML source code to file.
.DESCRIPTION
    This script downloads a given URLs HTML source code and saves it to a file.
.PARAMETER getsource
    URL to download the HTML source code from.
.PARAMETER directory
    Specifies a path to save results to. 
.PARAMETER savefile
    Specifies a filename to save to.
.PARAMETER -p
    Proxy server requires authentication.
.PARAMETER -u
    Use unauthenticated proxy or direct internet access.
.PARAMETER -s
    Use system configured proxy settings. Default parameter of no other parameters are set.
.PARAMETER -t
    Suppress screen output.
.EXAMPLE
    C:\PS> .\Get-Page-Source.ps1 -getsource www.google.com -directory C:\Temp -p
    Prompt for authentication details, get the HTML source code for www.google.com and save results to the C:\Temp directory.

.NOTES
    Author: Simon
    Date:   2016 APR 12
#>

[CmdletBinding(DefaultParameterSetName='-p')]

Param (    
    [Parameter(Mandatory=$true)][string]$getsource, 
    [Parameter(Mandatory=$true)][string]$directory, 
    [Parameter(Mandatory=$true)][string]$savefile,
    [Parameter(ParameterSetName='-p', Mandatory=$false)][switch]$p,
    [Parameter(ParameterSetName='-u', Mandatory=$false)][switch]$u,
    [Parameter(ParameterSetName='-s', Mandatory=$false)][switch]$s,
    [Parameter(Mandatory=$false)][switch]$t
)

function SaveResults { param([string]$results)
    if (-Not $t.IsPresent) {
        Write-Host $results | ConvertTo-HTML
    }

    #$savedir = "$directory\$(Get-Date -f yyyy_MMM_dd_HHMMss)_$getsource.source"
    $savedir = "$directory\$(Get-Date -f yyyy_MMM_dd_HHMMss)_$f.source"
    #$savedir = "$(Get-Date -f yyyy_MMM_dd_HHMMss)_$getsource.source"
    Write-Host $savedir
    [io.file]::WriteAllText($savedir, $results) # | ConvertTo-HTML
}

function Get-Results {
    $source_code = (Invoke-webrequest -URI $getsource -SessionVariable $web).Content   
    Return $source_code
}

if ($p.IsPresent) {
    $web = New-Object System.Net.WebClient
    $auth = Get-Credential
    $web.Proxy.Credentials=$auth
    $source = Get-Results
    SaveResults($source)
}

if ($u.IsPresent) {
    $source = Get-Results
    SaveResults($source)
}

if ($s.IsPresent) {
    $web = New-Object System.Net.WebClient
    $source = Get-Results
    SaveResults($source)
}

# Apply '-s' parameter if no proxy parameters are set.
if (($p -eq $false) -and ($s -eq $false) -and ($s -eq $false)) {
    $s = $true
}
