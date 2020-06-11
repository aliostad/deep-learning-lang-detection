<#

.SYNOPSIS
Queries the specified metascan server and retrieves operational statistics

.DESCRIPTION
Queries the specified metascan server and retrieves operational statistics

.EXAMPLE
Get-MetascanStatstics -Computername "671630-lteitg04" -checkperiod 1

.NOTES
Daryl Bizsley 2015

#>
function Get-MetascanEngines{
    param (
        [String]$Computername = $env:COMPUTERNAME
        )
    #MetaScan Rest API
    $enginesapi = "http://" + $Computername + ":8008/metascan_rest/stat/engines"
    #Query the rest interface
    try {
        $result = invoke-restmethod $enginesapi -method get -timeoutsec 5 -ErrorAction Stop
    }
    catch [System.Net.WebException]{
        $result = "Could not connect to rest api"
    }  
    return $result
}
