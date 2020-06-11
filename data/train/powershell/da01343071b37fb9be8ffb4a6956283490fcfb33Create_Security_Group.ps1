$cloudId=''

$postURL = "https://my.rightscale.com/api/clouds/$cloudId/security_groups"
$stringToPost = "security_group[name]=Security Group for API Sandbox&"+
"security_group[description]=Standard Security Group for use in my API Sandbox"
$bytesToPost = [System.Text.Encoding]::UTF8.GetBytes($stringToPost)


$webRequest = [System.Net.WebRequest]::Create($postURL)
$webRequest.Method = "POST"
$webRequest.Headers.Add("X_API_VERSION","1.5")
$webRequest.CookieContainer = $cookieContainer # recieved from authentication.ps1


$requestStream = $webRequest.GetRequestStream()
$requestStream.Write($bytesToPost, 0, $bytesToPost.Length)
$requestStream.Close()

[System.Net.WebResponse]$response = $webRequest.GetResponse()
$responseStream = $response.GetResponseStream()
$responseStreamReader = New-Object System.IO.StreamReader -ArgumentList $responseStream
[string]$responseString = $responseStreamReader.ReadToEnd()

$responseString