function Get-SSApitest {

param
    (
    [Parameter(Mandatory=$true)]
    $serv,
    $targ,
    [Parameter(Mandatory=$true)]
    [ValidateSet('Start','Stop','Restart')]
    $state
    )

$json_data = @{
        'key1' = 'value1'
        'key2' = $serv
        'key3' = $state
    } | ConvertTo-Json # Test connection

$postParams =  @{'St2-Api-Key'='[ADD STACKSTORM API KEY HERE]';"Content-Type"='application/json'} # Test connection

$server = "https://$targ"
$url = "/api/v1/webhooks/sample"

$ris = Invoke-WebRequest -Uri $server$url -Headers $postParams -Body $json_data -Method Post 

$script:objects = $ris.Content 
}