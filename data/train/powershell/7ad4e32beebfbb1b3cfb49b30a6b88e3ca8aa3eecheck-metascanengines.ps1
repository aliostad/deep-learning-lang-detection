<#

.SYNOPSIS
Queries the specified metascan server and retrieves operational statistics

.DESCRIPTION
Queries the specified metascan server and retrieves operational statistics

.EXAMPLE
Get-MetascanStatstics -Computername "671630-lteitg04" -checkperiod 1

.NOTES


#>
function Get-MetascanEngines{
    param (
        [String]$Computername = $env:COMPUTERNAME
        )
    #MetaScan Rest API
    $enginesapi = "http://" + $Computername + ":8008/metascan_rest/stat/engines"
    #Query the rest interface
    $enginesresult = invoke-restmethod $enginesapi -method get -timeoutsec 5
    if (!($enginesresult)){
        $result = "Could not connect to rest api"
    }
    if (!($result)){
        $result = $enginesresult
    }   
    return $result
}


$unknown = 3
$critical = 2
$warning = 1
$ok = 0
$metascanengines = Get-MetascanEngines
#Set failure conditions
if ($metascanengines -eq "Could not connect to rest api") {
	$nagiosexitcode = $critical
}
ELSEIF ($metascanengines | where {$_.def_time -lt (((get-date).adddays(-7)) -f "MM/dd/yyyy hh:mm:ss" + " AM")}) {
	$nagiosexitcode = $warning
}
ELSEIF ($metascanengines | where {$_.active -like "False*"}){
	$nagiosexitcode = $warning
}
ELSE {
	$nagiosexitcode = $ok
}
$metascanengines |select eng_name,eng_ver,def_time,active | ft -AutoSize
Exit $nagiosexitcode
