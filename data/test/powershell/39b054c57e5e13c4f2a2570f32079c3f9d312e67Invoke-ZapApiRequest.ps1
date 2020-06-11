<#
    .Synopsis
     This Script will Invoke ZAP API And will be call by various other scripts which needs to access ZAP API   
    .Example
     .\Invoke-ZapApiRequest [URL to attack] [Proxy from ZAP]
    .Notes
     Author: Mrityunjaya Pathak
     Date : March 2015
#>
param(
    #Url on which ZAP operation will be performed(only http url)
    $URL =$(throw "Missing URL value"),
    #ZAP Proxy URI   
    $proxy="http://localhost:8080",
    #stop ZAP if any error occurs
    [switch]$KillZapOnError
)

try{
    Invoke-WebRequest -uri $url -Proxy $proxy
    # write-host $s
}
catch{
    Write-Warning "$(get-date) $PSCommandPath : Invoke-Webrequest failed. $_"
    if($KillZapOnError.IsPresent){
        Stop-Zap -killonly
    }    
}