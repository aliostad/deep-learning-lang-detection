#get cookie container from authentication $cookieContainer

$SERVER=""

$webRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/servers/$SERVER")
$webRequest.Method = "DELETE"
$webRequest.CookieContainer = $cookieContainer
$webRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $webResponse = $webRequest.GetResponse()
$responseStream = $webResponse.GetResponseStream()
$responseStreamReader = New-Object System.IO.StreamReader -argumentList $responseStream
[string]$responseString = $responseStreamReader.ReadToEnd()


#response
#
#IsMutuallyAuthenticated : False
#Cookies                 : {}
#Headers                 : {Connection, Status, X-Runtime, X-Request-Uuid...}
#SupportsHeaders         : True
#ContentLength           : -1
#ContentEncoding         : 
#ContentType             : 
#CharacterSet            : 
#Server                  : nginx/1.0.15
#LastModified            : 2/21/2013 1:00:04 PM
#StatusCode              : NoContent
#StatusDescription       : No Content
#ProtocolVersion         : 1.1
#ResponseUri             : https://my.rightscale.com/api/deployments/365623001
#Method                  : DELETE
#IsFromCache             : False