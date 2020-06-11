function write-log
{ 


param(
    [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
    $message,
    [ValidateSet("ERROR","INFO","WARN")]
    $severity,
    $logfile

)




$WhatIfPreference=$false
$timeStamp = get-date -UFormat %Y%m%d-%I:%M:%S%p
switch ($severity)
 {

  "INFO" {$messageColor = "Green"}
  "ERROR" {$messageColor = "Red"}
  "WARN" {$messageColor = "Yellow"}
    
 }
 Write-Host "$($timeStamp) $($severity) $($message)" -ForegroundColor $messageColor
 if ($logfile.length -ge 0)
 {
    write-output "$($timeStamp) $($severity) $($message)" | Out-File -FilePath $logfile -Encoding ascii -Append
 }



}



$PSDefaultParameterValues = @{

"write-log:severity"="INFO";
"write-log:logfile"="$($env:ALLUSERSPROFILE)\GetADDomainconnection.log"
}


if ($log.Length -ne 0)
{
 if(Test-Path (split-path $log -parent))
 {
    $PSDefaultParameterValues["write-log:logfile"]=$log
    write-log "Setting location of log file to $($log)"

 }
 else
 {
    write-log "Custom log is not found setting log to   $($env:ALLUSERSPROFILE)\GetADDomainconnection.log"
 }

}
