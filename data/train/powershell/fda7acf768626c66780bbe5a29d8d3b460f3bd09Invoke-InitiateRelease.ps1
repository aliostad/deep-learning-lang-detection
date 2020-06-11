function Invoke-InitiateRelease
{
	[CmdletBinding()]  
	param(
        [Parameter(Mandatory=$true)]
        [string] $scheme = 'http',
		[string] $hostName,		
        [int] $portNumber = 1000,               
		[string] $apiVersion = '2.0',
        [Parameter(Mandatory=$true)]
		[string] $releaseTemplateName,
        [Parameter(Mandatory=$true)]
		[string] $deploymentPropertyBag
	)
    $queryParameters = @{ "releaseTemplateName" = $releaseTemplateName}
	$uri = Get-ReleaseApiUri `
        -scheme $scheme `
        -hostName $hostName `
        -portNumber $portNumber `
        -apiVersion $apiVersion `
        -action "InitiateRelease" `
        -queryParameters $queryParameters

    Invoke-WebRequest -Uri $uri -Method Get
}