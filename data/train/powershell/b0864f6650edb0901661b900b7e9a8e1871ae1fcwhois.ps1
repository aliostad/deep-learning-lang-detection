$domain = "example.com"
$key = "your whois api key"
$secret = "your whois api secret key"
$username = "your whois api username"

$time = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
$req=[Text.Encoding]::UTF8.GetBytes("{`"t`":$($time),`"u`":`"$($username)`"}")
$req = [Convert]::ToBase64String($req)

$data = $username + $time + $key
$hmac = New-Object System.Security.Cryptography.HMACMD5
$hmac.key = [Text.Encoding]::UTF8.GetBytes($secret)
$hash = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($data))
$digest = [BitConverter]::ToString($hash).Replace('-','').ToLower()

$uri = "https://www.whoisxmlapi.com/whoisserver/WhoisService?"`
     + "requestObject=$($req)&digest=$($digest)&domainName=$($domain)"

echo (Invoke-WebRequest -Uri $uri).Content