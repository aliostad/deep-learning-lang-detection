
if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $null ) {
  Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
}
. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
Connect-ExchangeServer -auto 

$apiKey = "your API key here"
$secretKey = "your secret key here"

#Requesting token
$url = "http://www.monitis.com/api?action=authToken&apikey=" + $apiKey + "&secretkey=" + $secretKey
$wc = new-object net.webclient
$resp = $wc.DownloadString($url).ToString()
$pos = $resp.IndexOf(":") + 2
$token = $resp.Substring($pos, $resp.Length - $pos - 2)

#Requests the monitor list in order to find the MonitorID
$tag = '[exchange+sample]'
$url = 'http://www.monitis.com/customMonitorApi?action=getMonitors&apikey=' + $apiKey + "&tag=" + $tag
$wc = new-object net.webclient
$resp = $wc.DownloadString($url).ToString()
$posL = $resp.IndexOf('id') + 5
$posR = $resp.IndexOf('","')
$monitorID = $resp.Substring($posL, $posR-$posL)

$messages = (Get-TransportServer | Get-Queue | Measure-Object MessageCount -sum).sum

#Uploading data
$nvc = new-object System.Collections.Specialized.NameValueCollection
$nvc.Add('apikey', $apikey)
$nvc.Add('validation', 'token')
$nvc.Add('authToken', $token)
$nvc.Add('timestamp', ((get-date).touniversaltime().ToString("yyyy-MM-dd HH:mm:ss").ToString()))
$nvc.Add('action', 'addResult')
$nvc.Add('monitorId', $monitorID)
$nvc.Add('checktime', ([int][double]::Parse((get-date((get-date).touniversaltime()) -UFormat %s))).ToString() + '000')
$nvc.Add('results', ('queued:' + $messages.tostring()) + ';' )

$wc = new-object net.webclient
$wc.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
$resp = $wc.UploadValues('http://www.monitis.com/customMonitorApi', $nvc)
[text.encoding]::ascii.getstring($resp)

