#get cookie container from authentication $cookieContainer

$listDeploymentsRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/deployments.xml")
$listDeploymentsRequest.Method = "GET"
$listDeploymentsRequest.CookieContainer = $cookieContainer
$listDeploymentsRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $listDeploymentsResponse = $listDeploymentsRequest.GetResponse()
$listDeploymentsResponseStream = $listDeploymentsResponse.GetResponseStream()
$listDeploymentsResponseStreamReader = New-Object System.IO.StreamReader -argumentList $listDeploymentsResponseStream
[string]$listDeploymentsResponseString = $listDeploymentsResponseStreamReader.ReadToEnd()
write-host $listDeploymentsResponseString

#response same as curl response
