function Invoke-InitiateReleaseFromBuild
{
	[CmdletBinding()]  
	param(
        [Parameter(Mandatory=$true)]
        [string] $scheme = 'http',
		[string] $hostName,		
        [int] $portNumber = 1000,               
		[string] $apiVersion = '2.0',
        [Parameter(Mandatory=$true)]
		[string] $teamFoundationServerUrl,
        [Parameter(Mandatory=$true)]
		[string] $teamProject,
        [Parameter(Mandatory=$true)]
		[string] $buildDefinition,
        [Parameter(Mandatory=$true)]
		[string] $buildNumber,
        [Parameter(Mandatory=$true)]
		[string] $targetStageName
	)

    $queryParameters = @{         
        "teamFoundationServerUrl"=$teamFoundationServerUrl;
        "teamProject"=$teamProject;
        "buildDefinition"=$buildDefinition;
        "buildNumber"=$buildNumber;
        "targetStageName"=$targetStageName;
    }

	$uri = Get-ReleaseApiUri `
        -scheme $scheme `
        -hostName $hostName `
        -portNumber $portNumber `
        -apiVersion $apiVersion `
        -action "InitiateReleaseFromBuild" `
        -queryParameters $queryParameters

    Invoke-WebRequest -Uri $uri -Method Get
}