#get cookie container from authentication $cookieContainer

$deploymentID = "365623001"

$deleteDeploymentsRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/deployments/$deploymentID")
$deleteDeploymentsRequest.Method = "DELETE"
$deleteDeploymentsRequest.CookieContainer = $cookieContainer
$deleteDeploymentsRequest.Headers.Add("X_API_VERSION", "1.5");

[System.Net.WebResponse] $deleteDeploymentsResponse = $deleteDeploymentsRequest.GetResponse()
$deleteDeploymentsResponseStream = $deleteDeploymentsResponse.GetResponseStream()
$deleteDeploymentsResponseStreamReader = New-Object System.IO.StreamReader -argumentList $deleteDeploymentsResponseStream
[string]$deleteDeploymentsResponseString = $deleteDeploymentsResponseStreamReader.ReadToEnd()

$deleteDeploymentsResponse

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