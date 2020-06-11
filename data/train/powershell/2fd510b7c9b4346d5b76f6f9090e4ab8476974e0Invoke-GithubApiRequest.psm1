function Invoke-GithubApiRequest{
<#
 
.SYNOPSIS
    Given HTTP parameters and credentials will invoke an HTTP request to the Github API.
.DESCRIPTION
    Given HTTP parameters and credentials will invoke a HTTP request to the Github API using Invoke-RestMethod.

.NOTES
	Requirements: Copy this module to any location found in $env:PSModulePath
.PARAMETER uri
	Required. The complete Uri to use in the HTTP request.
.PARAMETER method
	Required. The HTTP method to use in the HTTP request, valid options are 'GET' or 'POST'
.PARAMETER githubApiKey
	Required. An active Github API token to authenticate against the Github API with.
.PARAMETER body
	Optional. A valid and escaped JSON string body to pass with the request.
.EXAMPLE 
	Import-Module Invoke-GithubApiRequest
	Import the module
.EXAMPLE	
	Get-Command -Module Invoke-GithubApiRequest
	List available functions
.EXAMPLE
	Invoke-GithubApiRequest -uri "https://api.github.com/repos/lloydstone/femah/releases" -method GET -githubApiKey "c2e14cc45b7977286d576b0e4d8bb5ff2767364a"
	Execute the module
#>
	[cmdletbinding()]
		Param(
			[Parameter(
				Position = 0,
				Mandatory = $True )]
				[string]$uri,		
			[Parameter(
				Position = 1,
				Mandatory = $True )]
				[string]$method,
			[Parameter(
				Position = 2,
				Mandatory = $True )]
				[string]$githubApiKey,
			[Parameter(
				Position = 3,
				Mandatory = $False )]
				[string]$body				
			)

	Begin {
			$DebugPreference = "Continue"
		}	
	Process {
				Try 
				{
					
					$params = @{
					  Uri = $uri;
					  Method = $method;
					  Headers = @{
						Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($githubApiKey):x-oauth-basic"));
						UserAgent = 'User-Agent: femah-deployment-pipeline'
					  }
					  ContentType = 'application/json';
					  Body = if ($body -ne "") { $body };
					}  
					
					return Invoke-RestMethod @params
				}
				catch [Exception] {
					throw "Error executing request to Github API: `r`n $_"
				}
		}
}