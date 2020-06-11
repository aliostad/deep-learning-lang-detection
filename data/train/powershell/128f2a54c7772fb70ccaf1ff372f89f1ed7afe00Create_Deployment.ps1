#get cookie container from authentication $cookieContainer

$deploymentName = "Deployment for API Sandbox"
$deploymentDescription = "Sandbox for Miscellaneous API Tests"

$postString = "deployment[name]=""$deploymentName""&deployment[description]=$deploymentDescription"
$postBytes = [System.Text.Encoding]::UTF8.GetBytes($postString)

$createDeploymentRequest = [System.Net.WebRequest]::Create("https://my.rightscale.com/api/deployments.xml")
$createDeploymentRequest.Method = "POST"
$createDeploymentRequest.CookieContainer = $cookieContainer
$createDeploymentRequest.Headers.Add("X_API_VERSION", "1.5");


$createDeploymentRequestStream = $createDeploymentRequest.GetRequestStream()
$createDeploymentRequestStream.Write($postBytes, 0, $postBytes.Length)
$createDeploymentRequestStream.Close()

[System.Net.WebResponse] $createDeploymentResponse = $createDeploymentRequest.GetResponse()
$createDeploymentResponseStream = $createDeploymentResponse.GetResponseStream()
$createDeploymentResponseStreamReader = New-Object System.IO.StreamReader -argumentList $createDeploymentResponseStream
[string]$createDeploymentResponseString = $createDeploymentResponseStreamReader.ReadToEnd

$createDeploymentResponse

#Response:
#
#IsMutuallyAuthenticated : False
#Cookies                 : {}
#Headers                 : {Transfer-Encoding, Connection, Status, X-Runtime...}
#SupportsHeaders         : True
#ContentLength           : -1
#ContentEncoding         : 
#ContentType             : text/html; charset=utf-8
#CharacterSet            : utf-8
#Server                  : nginx/1.0.15
#LastModified            : 2/21/2013 12:54:34 PM
#StatusCode              : Created
#StatusDescription       : Created
#ProtocolVersion         : 1.1
#ResponseUri             : https://my.rightscale.com/api/deployments.xml
#Method                  : POST
#IsFromCache             : False