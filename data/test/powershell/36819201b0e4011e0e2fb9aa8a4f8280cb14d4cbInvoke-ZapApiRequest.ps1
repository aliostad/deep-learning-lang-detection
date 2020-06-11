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
    if($KillZapOnError.IsPresent){
        $process =gwmi win32_process |where processname -match javaw  |where commandLine -match zap | select processid  
        if( $process.processid -gt 0){
            stop-process $process.processid
        }
    
    }    
}