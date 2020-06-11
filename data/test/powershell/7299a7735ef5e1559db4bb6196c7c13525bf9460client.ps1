Function New-LeanKitAuthentation
{
    Param(
         [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
            ]$Hostname,
         [Parameter(
            Position=1,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
            ]$userName,
         [Parameter(
            Position=2,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
            ]$password,
         [Parameter(
            Position=1,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
            ]$credential
    )
    #$auth = New-Object LeanKit.API.Client.Library.LeanKitBasicAuth -ArgumentList @{	'Hostname' = $Hostname; 'Username' = $userName; 'Password' = $password}
    #todo client:auth:Input validation would be nice
    #todo client:auth:Deal with a credential object if it was passed in
    $auth = New-Object LeanKit.API.Client.Library.LeanKitBasicAuth
    $auth.Hostname = $Hostname
    $auth.Username = $userName
    $auth.Password = $password

    return $auth
}

function New-LeanKitClient
{
    Param(
         [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)
            ]$leanKitAuth
    )
    $factory = New-Object LeanKit.API.Client.Library.LeanKitClientFactory
    $api = $factory.Create($leanKitAuth)

    return $api
}
