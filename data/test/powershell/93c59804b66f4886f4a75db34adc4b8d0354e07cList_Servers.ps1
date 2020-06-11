#get cookie container from authentication $cookieContainer
$DEPLOYMENT=""

$webRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/deployments/$DEPLOYMENT/servers.xml")
$webRequest.Method = "GET"
$webRequest.CookieContainer = $cookieContainer
$webRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $webResponse = $webRequest.GetResponse()
$responseStream = $webResponse.GetResponseStream()
$responseStreamReader = New-Object System.IO.StreamReader -argumentList $responseStream
[string]$responseString = $responseStreamReader.ReadToEnd()
$responseString

#response same as curl response
