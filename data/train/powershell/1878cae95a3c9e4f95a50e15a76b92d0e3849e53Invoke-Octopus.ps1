param(
  [Parameter(Mandatory=$true)]
  [SecureString]
  $ApiKey,
  
  [String]
  $Path = "/api",
  
  [String]
  $OctopusHost = "deploy"
)

if (-not $Path.StartsWith("/")) { $Path = "/$Path" }
if (-not $Path.StartsWith("/api")) { $Path = "/api$Path" }
$url = "http://$OctopusHost$Path"
$headers = @{ "X-Octopus-ApiKey" = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($apikey)) } 
Invoke-RestMethod -Method Get -Uri $url -Headers $headers
