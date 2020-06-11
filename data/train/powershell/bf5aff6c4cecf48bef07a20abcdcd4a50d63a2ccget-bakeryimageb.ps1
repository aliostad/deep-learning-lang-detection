param([int]$Provider,[string]$CommonName,[int]$ImageType,[string]$user,[string]$pass)

$base64AuthInfo=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass)))



#$r=invoke-restmethod -URI "http://localhost/bakeryapi2/api/image/?CommonName=${CommonName}&ImageType=${ImageType}&Provider=${Provider}&Latest=true" -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
$r=invoke-restmethod -URI "http://webbake/bakery/api/image/?CommonName=${CommonName}&ImageType=${ImageType}&Provider=${Provider}&Latest=true" -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
#$r=invoke-restmethod -URI "http://localhost:65316/api/image/?CommonName=${CommonName}&ImageType=${ImageType}&Provider=${Provider}" -Method Get
$r