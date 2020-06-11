#get cookie container from authentication $cookieContainer

$deploymentID = "deploymentID"

$listInputsRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/deployments/$deploymentID/inputs.xml")
$listInputsRequest.Method = "GET"
$listInputsRequest.CookieContainer = $cookieContainer
$listInputsRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $listInputsResponse = $listInputsRequest.GetResponse()
$listInputsResponseStream = $listInputsResponse.GetResponseStream()
$listInputsResponseStreamReader = New-Object System.IO.StreamReader -argumentList $listInputsResponseStream
[string]$listInputsResponseString = $listInputsResponseStreamReader.ReadToEnd()
write-host $listInputsResponseString

#response same as curl response
