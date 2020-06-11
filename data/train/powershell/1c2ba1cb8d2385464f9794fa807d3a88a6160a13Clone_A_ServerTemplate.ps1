$ST=""                           # STID to clone.  Obtain via the Dashboard or using the API to List STs.

$postURL = "https://my.rightscale.com/api/server_templates/$ST/clone"
$stringToPost = "server_template[name]=HAProxy Clone22&"+ 
"server_template[description]=ST Clone via API"
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