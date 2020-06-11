$script:_projectId = $null
$script:_apiKeys = @{}
$script:_defaultCollectionName = $null

function Get-ConnectApiKey
{
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Push', 'Query')]
        [string]$KeyType
    )

    if ($script:_apiKeys[$KeyType]) 
    {
        return $script:_apiKeys[$KeyType]
    }

    if ($script:_apiKeys['PushQuery']) 
    {
        return $script:_apiKeys['PushQuery']
    }

    throw "API key not set, use 'Set-ConnectApiKey -KeyType $KeyType' to set it"
}

function Get-ConnectProjectId
{
    if ($script:_projectId) 
    {
        return $script:_projectId
    }

    throw 'ProjectID not set, use "Set-ConnectApiKey -ProjectId" to set it'
}

function Check-CollectionName([string]$CollectionName)
{
    if (-not $CollectionName)
    {
        throw "Specify CollectionName or set default ocllection name with 'Set-ConnectApiKey -DefaultCollectionName'"
    }
}

function Set-ConnectApiKey
{
    param(
        [string]$ProjectId,
        [ValidateSet('Push', 'Query', 'PushQuery')]
        [string]$KeyType,
        [string]$ApiKey,
        [string]$DefaultCollectionName
    )

    if ($ApiKey) 
    {
        if (-not $KeyType) 
        {
            throw "Specify KeyType"
        }
        $script:_apiKeys[$KeyType] = $ApiKey
    }

    if ($ProjectId)
    {
        $script:_projectId = $ProjectId
    }

    if ($DefaultCollectionName)
    {
        $script:_defaultCollectionName = $DefaultCollectionName
    }
}

function Get-ConnectEvents
{
    param(
        [string]$CollectionName = $script:_defaultCollectionName
    )

    Check-CollectionName $CollectionName

    $response = Invoke-WebRequest -uri "https://api.getconnect.io/events/$CollectionName/export?query=%7B%7D" `
        -Method Get -Headers @{
        'X-Project-Id' = Get-ConnectProjectId
        'X-Api-Key' = Get-ConnectApiKey -KeyType Query
    }
    
    return ($response.Content | ConvertFrom-Json).results
}

function Push-ConnectEvent
{
    param(
        [string]$CollectionName = $script:_defaultCollectionName,
        $event
    )

    Check-CollectionName $CollectionName

    $response = Invoke-WebRequest -uri "https://api.getconnect.io/events/$CollectionName" `
        -Method Post -Headers @{
        'X-Project-Id' = Get-ConnectProjectId
        'X-Api-Key' = Get-ConnectApiKey -KeyType Push
    } -Body ($event | ConvertTo-Json)
}

Export-ModuleMember -Function @(
    'Set-ConnectApiKey',
    'Get-ConnectEvents',
    'Push-ConnectEvent'
)