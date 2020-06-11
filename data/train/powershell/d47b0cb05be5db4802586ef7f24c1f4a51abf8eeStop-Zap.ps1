<#
    .Synopsis
    This script will stop the active session of ZAP
    .Example
    .\Stop-Zap [Proxy for ZAP]
    This will stop and close ZAP session
    .Notes
    Author: Mrityunjaya Pathak
    Date : March 2015
#>
param(
    #ZAP Proxy URI
    $proxy='http://localhost:8080',
    $sleep=1 
)
$ErrorActionPreference="stop"
$apicheck=&$PSScriptRoot\Invoke-ZapApiRequest 'http://zap/' $proxy -KillZapOnError
if ($apicheck.StatusCode -eq 200) {
    &$PSScriptRoot\Invoke-ZapApiRequest 'http://zap/JSON/core/action/shutdown/?zapapiformat=JSON' $proxy|Out-Null
    while(($status.StatusCode -eq 200) -and ($count -le 10)){
        Start-Sleep -s $sleep
        $count +=1
        $status=.$PSScriptRoot\Invoke-ZapApiRequest 'http://zap/' $proxy -KillZapOnError
        Write-Host 'o'
    }
}
else{
    $process =gwmi win32_process |where processname -match javaw  |where commandLine -match zap | select processid  
    if( $process.processid -gt 0){
        stop-process $process.processid
    }   
}
Write-host "Zap stopped"


  