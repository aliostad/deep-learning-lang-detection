function AddCustMon([string] $name, [string] $monitorParams, [string] $resultParams, [string] $row, [string] $column) {
  Write-Host "Adding Custom Monitor " $name
  $nvc = new-object System.Collections.Specialized.NameValueCollection
  $nvc.Add('apikey', $apikey)
  $nvc.Add('validation', 'token')
  $nvc.Add('authToken', $token)
  $nvc.Add('timestamp', (get-date).touniversaltime().ToString("yyyy-MM-dd HH:mm:ss"))
  $nvc.Add('action', 'addMonitor')
  $nvc.Add('monitorParams', $monitorParams)
  $nvc.Add('resultParams', $resultParams)
  $nvc.Add('name', $name )
  $nvc.Add('tag', 'ParseLog' )

  $wc = new-object net.webclient
  $wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
  $resp = $wc.UploadValues('http://www.monitis.com/customMonitorApi', $nvc)
  $resp = [text.encoding]::ascii.getstring($resp)
  $pos = $resp.IndexOf("data") + 6
  $testID = $resp.Substring($pos, $resp.Length - $pos - 1)
  $testID
  
  write-host "Adding test " $name " to the page"
  $nvc = new-object System.Collections.Specialized.NameValueCollection
  $nvc.Add('apikey', $apikey)
  $nvc.Add('validation', 'token')
  $nvc.Add('authToken', $token)
  $nvc.Add('timestamp', (get-date).touniversaltime().ToString("yyyy-MM-dd HH:mm:ss"))
  $nvc.Add('action', 'addPageModule')
  $nvc.Add('moduleName', 'CustomMonitor')
  $nvc.Add('pageId', $pageID)
  $nvc.Add('column', $column )
  $nvc.Add('row', $row )
  $nvc.Add('dataModuleId', $testID)

  $wc = new-object net.webclient
  $wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
  $resp = $wc.UploadValues('http://www.monitis.com/api', $nvc)
  [text.encoding]::ascii.getstring($resp)
}

$apiKey = "Your API key here"
$secretKey = "Your Secret key here"

write-host "Requesting token"
$url = "http://www.monitis.com/api?action=authToken&apikey=" + $apiKey + "&secretkey=" + $secretKey
$wc = new-object net.webclient
$resp = $wc.DownloadString($url).ToString()
$pos = $resp.IndexOf(":") + 2
$token = $resp.Substring($pos, $resp.Length - $pos - 2)
write-host "Token: " $token

write-host "Adding a page"
$nvc = new-object System.Collections.Specialized.NameValueCollection
$nvc.Add('apikey', $apikey)
$nvc.Add('validation', 'token')
$nvc.Add('authToken', $token)
$nvc.Add('timestamp', (get-date).touniversaltime().ToString("yyyy-MM-dd HH:mm:ss"))
$nvc.Add('action', 'addPage')
$nvc.Add('title', 'ParseLog')
$nvc.Add('columnCount', '2')

$wc = new-object net.webclient
$wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
$resp = $wc.UploadValues('http://www.monitis.com/api', $nvc)
$resp = [text.encoding]::ascii.getstring($resp)
$resp
$pos = $resp.IndexOf("pageId") + 8
$pageID = $resp.Substring($pos, $resp.Length - $pos - 2)
$pageID 

AddCustMon 'Log1' 'Log1:First Log file:TextMatch:3:false;;' 'match:Match:N%2FA:2;' '1' '1'
