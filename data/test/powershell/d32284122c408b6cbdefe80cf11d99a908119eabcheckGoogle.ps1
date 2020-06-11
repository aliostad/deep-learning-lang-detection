$serverToTest = "www.google.ca"

$baseModemURL = "http://192.168.100.1"
$modemStatsURL = $baseModemURL + "/Diagnostics.asp"

$localSavePath = "C:\tmp\modem-stats"
New-Item -ItemType directory -Path $localSavePath -force | Out-Null

$modemStatsLocalFile = "$localSavePath\modem-stats-$(get-date -f yyyy-MM-dd-HH-mm-ss).txt"

"Testing Connection to $serverToTest"

if ((Test-Connection -Cn $serverToTest -BufferSize 16 -Count 1 -ea 0 -quiet))
{
    "Problem connecting to $serverToTest - gathering logs"
    "Writing modem stats information to $modemStatsLocalFile"

    try
    {
        $wc = New-Object System.Net.WebClient
        $wc.set_Timeout
        $wc.DownloadFile($modemStatsURL,$modemStatsLocalFile)
    }
    catch [System.Net.WebException]
    {
        $exceptionStr = $_.Exception.ToString()
        "Exception trying to download $modemStatsURL"
        Add-content $modemStatsLocalFile -value "EXCEPTION trying to download $modemStatsURL"
        Add-content $modemStatsLocalFile -value $exceptionStr
    }

} else
{
    "$serverToTest is reachable"
}