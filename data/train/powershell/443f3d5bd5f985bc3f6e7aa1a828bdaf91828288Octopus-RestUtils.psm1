# All Rest helpers for Octopus here

$RequiredPSVersionMajor = 3

function Octopus-CreateRequest
{ 
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $url, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey, 

		[Parameter(Mandatory=$true)]
		[String] $method,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)

	if ($PSVersionTable.PSVersion.Major -ge $RequiredPSVersionMajor)
	{
		$headers = @{"X-Octopus-ApiKey"=$apiKey}
		$contentType = "application/json"
		if ($psCredential -eq $null)
		{
			return Invoke-RestMethod -Uri $server$url -ContentType $contentType -Headers $headers -Method $method -UseDefaultCredentials -Verbose
		}
		else
		{
			#return Invoke-RestMethod -Uri $server$url -ContentType $contentType -Headers $headers -Method $method -Credential $psCredential -Verbose
			return Invoke-RestMethod -Uri $server$url -Credential $psCredential -Verbose
		}
	}
	else
	{
		throw "PS version 3.0+ is required"
	}
}


Export-ModuleMember Octopus-CreateRequest