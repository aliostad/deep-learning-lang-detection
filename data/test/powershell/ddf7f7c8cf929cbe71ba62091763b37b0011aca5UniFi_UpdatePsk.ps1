$wlanName = "" # Name of the WLAN to update
$site = "https://127.0.0.1:8443"
$username = ""
$password = ""

# Logic for generating new PSK key

$psk = "Your new PSK" 
"PSK: $psk" | Write-Host

# Allow self signed certifiactes.
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

$mySession = $null

$param = "{'username':'${username}','password':'${password}'}"
$url = "$site/api/login"
Invoke-RestMethod -SessionVariable mySession -Uri $url -Method Post -Body $param | out-null

$param = "json={}"
$url = "$site/api/s/default/list/wlanconf"
$wlanList = Invoke-RestMethod -WebSession $mySession -Uri $url -Method Post -Body $param

$wlanConfig = $wlanList.data | Where { $_.name -eq $wlanName }

if ($wlanConfig -eq $null) {
    throw "WLAN-Configuration not found: " + $wlanName
}

$wlanConfigId = $wlanConfig._id
$wlanConfig.PSObject.Properties.Remove('_id')
$wlanConfig.x_passphrase = $psk

$url = "$site/api/s/default/upd/wlanconf/$wlanConfigId"
$wlanConfig | ConvertTo-Json -Compress -OutVariable jsonConfig | out-null
$param = "json=$jsonConfig"
$apiResult = Invoke-RestMethod -WebSession $mySession -Uri $url -Method Post -Body $param

$apiResult.meta.rc | Write-Host
