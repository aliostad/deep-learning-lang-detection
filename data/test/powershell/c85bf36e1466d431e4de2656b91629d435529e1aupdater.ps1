$currentPath=Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
Import-Module ("{0}\updater-functions.ps1" -f $currentPath)

$hostname = "HOSTNAME (fqdn)"
$authEmail = "CLOUDFLARE AUTH EMAIL"
$authKey = "CLOUDFLARE AUTH KEY"
$zoneName = "CLOUDFLARE ZONE NAME (fqdn)"

$regkey = 'HKCU:\Software\bennettp123\cfupdater'

# get oldip from registry
$oldip = $( (Get-ItemProperty -path $regkey).oldip 2>$null )
if (-not $oldip) { $oldip = "UNKNOWN"; }

# get newip
$myip = $null
#$myip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -ExpandProperty ip

# or, to use a custom IP:
$myip = @(Get-IPAddresses | where { $_ -match "10.25.64.*" })[0]

if (-not $myip) { throw "IP unset or invalid" }

# quit if oldip == newip
if ($myip -eq $oldip) { exit 0; }

$headers = @{
  'X-Auth-Email' = $authEmail
  'X-Auth-Key' = $authKey
}

# get zone id
$zone = Invoke-RestMethod -Headers $headers -Method GET -Uri ("https://api.cloudflare.com/client/v4/zones/?name={0}" -f $zoneName)
if (-not $zone) { throw "Error getting zone from CF API" }
if ($zone.result.count -lt 1) { throw "Error getting zone from CF API" }
$zoneid = $zone.result.id

# get current record from cloudflare
$oldip_cf = "UNKNOWN"
$dns = Invoke-RestMethod -Headers $headers -Method GET -Uri ("https://api.cloudflare.com/client/v4/zones/{0}/dns_records/?name={1}" -f $zoneid, $hostname)

Invoke-Command {
	if ($dns.result.count -gt 0) {
		# already exists, update
		$oldip_cf = $dns.result.content -replace '\s',''
        #if ($myip -eq $oldip_cf) { exit 0; }
		$dnsid = $dns.result.id
		$dns.result | Add-Member "content" $myip -Force
		$body = $dns.result | ConvertTo-Json
		Invoke-RestMethod -Headers $headers -Method PUT -Uri ("https://api.cloudflare.com/client/v4/zones/{0}/dns_records/{1}" -f $zoneid, $dnsid) -Body $body -ContentType "application/json"
	} else {
		# does not exist; create
		$body = @{
			"type" = "A"
			"name" = $hostname
			"content" = $myip
		} | ConvertTo-Json
		Invoke-RestMethod -Headers $headers -Method POST -Uri ("https://api.cloudflare.com/client/v4/zones/{0}/dns_records" -f $zoneid) -Body $body -ContentType "application/json"
	}
} | ForEach-Object {
	$newip = $_.result.content -replace '\s',''
	if ($newip) {
		New-Item -Path $regkey -Type directory -Force
		Set-ItemProperty -path $regkey -name oldip -value $newip
	}
}
