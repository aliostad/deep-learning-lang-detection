$apiKey = "Your API Key Here"
$URLResource = "https://serverURL/api/bit9platform/v1/computer"
$ActiveComputers = $URLResource+"?q=deleted:false"

$Computers = Invoke-RestMethod -Uri $ActiveComputers -Method Get -Header @{ "X-Auth-Token" = $apiKey } 

$HashTable = @{}
foreach($Computer in $Computers)
{
	$HashTable[$Computer.name] = $Computer.id
}
$HashTable.GetEnumerator() | sort Name,Value -Descending
foreach ($Instance in $Computers)
{
    $comp = $Instance.name
    $ID = $Instance.id
    $Unique = $HashTable.ContainsValue($ID)
    if ( $Unique -ne $true )
    {
    $deleteCall = $URLResource + "/$ID"
    Invoke-RestMethod -Uri $deleteCall -Method Delete -Header @{ "X-Auth-Token" = $apiKey }
    }
}
