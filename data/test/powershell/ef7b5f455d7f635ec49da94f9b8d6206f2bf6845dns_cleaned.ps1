clear
$accounts = 
#Script for DNS
#Variable declaration
$tokenURI="https://identity.api.rackspacecloud.com/v2.0/tokens"
$user=
$apikey=
$jsonrackkey=@{"auth"= @{
                        "RAX-KSKEY:apiKeyCredentials" = 
                            @{

                        "username"= $($user)
                        "apiKey"=$($apikey)
                              }
                        }
             } | Convertto-Json
$lb=$env:lbs
$account=
$ContentType="application/json"
$jenkinsserver=$env:servername
$dnsid=
$i=0
$dnsURI="https://dns.api.rackspacecloud.com/v1.0/$account/domains/$dnsid/?limit=100&offset=$i&showRecords=true&showSubdomains=true"
Write-Host "DNS URI is $dnsURI"
$noderequest=@{"node"= @{
"condition"= $($condition)}} | Convertto-Json
#Main
#Gets the token from Rackspace
Write-Host "Token request"
$token=Invoke-Webrequest -Uri $tokenURI -Method Post -Body $jsonrackkey -ContentType "application/json"
$jsonResult=$token.Content | Convertfrom-Json
$XAuthToken=$jsonResult.access.token.id
$TenantID=$jsonResult.access.token.tenant
#Gets the total number of DNS records
$headers=@{"X-Auth-Token" = $XAuthToken; "X-Project-Id"=$TenantID; "Accept" = "Application/json"}
$nodes=Invoke-WebRequest -Uri $dnsURI  -ContentType $ContentType -Headers $headers -Method Get
$jsonNodesResult=$nodes.Content | convertfrom-Json
$totalEntries=$jsonNodesResult.recordsList.totalEntries
for ($i=0; $i-le $totalEntries; $i+=100)
{
$dnsURI="https://dns.api.rackspacecloud.com/v1.0/$account/domains/$dnsid/?limit=100&offset=$i&showRecords=true&showSubdomains=true"
$nodes=Invoke-WebRequest -Uri $dnsURI  -ContentType application/json -Headers $headers -Method Get
$jsonNodesResult=$nodes.Content | convertfrom-Json
$totalEntries=$jsonNodesResult.recordsList.totalEntries
foreach ($element in $jsonNodesResult.recordsList){
$element.records.name | Add-Content c:\scripts\dns.txt
}
}
