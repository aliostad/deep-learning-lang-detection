$json = @'
{
   "jsonrpc" : "2.0",
   "method" : "getApiForUsername",
   "params" : {
      "username" : "lrector@beehiveindustries.com"
   },
   "id" : "apeye"
}
'@
$Uri = "api.nutshell.com/v1/json"

$Response = Invoke-RestMethod -Uri $Uri -Method Post -Body ($json)

$Target = $Response.result.api

$ApiUri = "https://$Target/api/v1/json"
$ApiUri

$Payload = @'
{
	"jsonrpc" : "2.0",
	"method" : "findBackups",
	"id" : "lrector@beehiveindustries.com",
	"params" : {
				[]
				}
}
'@

$username = "lrector@beehiveindustries.com"
$password = get-content apikey.txt

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$head = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# $Backups = invoke-restmethod -Uri $ApiUri -Headers $head -Method Post -Body ($Payload) 

# Invoke-RestMethod -Uri $ApiUri -Method Post -Body ($Payload) -Headers $head
