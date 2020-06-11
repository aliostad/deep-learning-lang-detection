#get cookie container from authentication $cookieContainer

$webRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/permissions.xml")
$webRequest.Method = "GET"
$webRequest.CookieContainer = $cookieContainer
$webRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $listInstanceTypesResponse = $webRequest.GetResponse()
$listInstanceTypesResponseStream = $listInstanceTypesResponse.GetResponseStream()
$listInstanceTypesResponseStreamReader = New-Object System.IO.StreamReader -argumentList $listInstanceTypesResponseStream
[string]$listInstanceTypesResponseString = $listInstanceTypesResponseStreamReader.ReadToEnd()
write-host $listInstanceTypesResponseString

#response same as curl response
