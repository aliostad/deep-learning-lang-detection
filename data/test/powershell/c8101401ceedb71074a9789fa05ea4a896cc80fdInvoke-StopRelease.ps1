function Invoke-StopRelease
{
	[CmdletBinding()]  
	param(
        [Parameter(Mandatory=$true)]
        [string] $scheme = 'http',
		[string] $hostName,		
        [int] $portNumber = 1000,
        [string] $apiVersion = '2.0',
        [Parameter(Mandatory=$true)]
		[string] $releaseId
		
	)
    $queryParameters = @{ "releaseId" = $releaseId}
	$uri = Get-ReleaseApiUri `
        -scheme $scheme `
        -hostName $hostName `
        -portNumber $portNumber `
        -apiVersion $apiVersion `
        -action "StopRelease" `
        -queryParameters $queryParameters

    Invoke-WebRequest -Uri $uri -Method Get
}