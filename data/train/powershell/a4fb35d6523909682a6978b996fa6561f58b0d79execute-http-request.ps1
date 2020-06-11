Function hasPropertyDefined($deployed, $propname) {
  $has = $deployed | Get-Member -name $propname | format-list
    return $has.count -gt 0
}

Write-Host "Tested URL" $deployed.url "with the following parameters"
$webparams = @{}
$webparams["URI"]=$deployed.url
$webparams["TimeoutSec"]=$deployed.timeout
$webparams["Method"]=$method
if( hasPropertyDefined $deployed "postData" ) {
  $webparams["ContentType"]=$deployed.contentType
    $webparams["Body"]=$deployed.postData
}Elseif( hasPropertyDefined $deployed "file" ) {
  $webparams["ContentType"]=$deployed.contentType
    $webparams["InFile"]=$deployed.file
}
#TODO Manage headers
#$headers = @{}
#$headers["Content-Type"] = $deployed.contentType
#$headers
Write-Host @webparams


$status = "OK"
Start-Sleep -s $deployed.startDelay

for($f=1;$f -le $deployed.maxRetries;$f++)
{
  try {
    Write-Host "Attempt " $f
      $request = Invoke-WebRequest @webparams
      break
  } catch {
    Write-Host "ERROR: " $_.Exception.Message
      $status = "KO"
  }
  Start-Sleep -s $deployed.retryWaitInterval
}

if( $status -eq "KO") {
  Throw "ERROR: Too Many Attempts"
}

if( $deployed.showPageInConsole ) {
  Write-Host $request
}

Write-Host "Testing the content"

if($deployed.expectedResponseText){
  $find = $request.AllElements | where {$_.innerhtml -like "*$($deployed.expectedResponseText)*"}
  if( $find.count -eq 0) {
    Write-Host "ERROR: Response body did not contain: '" $deployed.expectedResponseText "'"
      Exit 1
  } else {
    Write-Host "Response body contains: '" $deployed.expectedResponseText "'"
  }
}

if($deployed.unexpectedResponseText){
  $find = $request.AllElements | where {$_.innerhtml -like "*$($deployed.unexpectedResponseText)*"}
  if( $find.count -eq 0) {
    Write-Host "Response body does not contain: '" $deployed.unexpectedResponseText "'"
  } else {
    Write-Host "ERROR: Response body did contain: '" $deployed.unexpectedResponseText "'"
      Exit 1
  }
}



