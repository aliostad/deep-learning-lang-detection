$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
Import-Module (Join-Path $ScriptDirectory Octopus-RestUtils.psm1)


# All Get requests to Octopus here


function Octopus-Get 
{ 
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $url, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)

	return Octopus-CreateRequest $server $url $apiKey Get $psCredential
}



function Octopus-GetProjects
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)
	return Octopus-Get $server "/api/projects" $apiKey $psCredential
}



function Octopus-GetEnvironments
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)
	
	return Octopus-Get $server "/api/environments" $apiKey $psCredential
}



function Octopus-GetProject
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$true)]
		[String]$projectName,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)
	
	$projects = Octopus-GetProjects $server $apiKey $psCredential # | Where-Object {$_.Name -eq $projectName})
	if ($projects -ne $null)
	{
		foreach($project in $projects)
		{		
			Write-Host $project.Name
			if ($project.Name -eq $projectName)
			{
				return $project
			}
		}
	}
	
	return $null
}



function Octopus-GetEnvironment
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$true)]
		[String]$environmentName,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential
	)

	return Octopus-GetEnvironments $server $apiKey $psCredential | Where-Object {$_.Name -eq $environmentName}
}



function Octopus-GetProjectSteps
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$true)]
		[String]$projectName,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential,

		#TODO:NIKO
		[Parameter(Mandatory=$false)]
		[String]$destinationRoles
	)

	$project = Octopus-GetProject $server $apiKey $projectName $psCredential
	if ($project -ne $null)
	{
		return Octopus-Get $server $project.Links.Steps $apiKey $psCredential
	}

	return $null
}



function Octopus-GetProjectVariables
{
	param
	(
		[Parameter(Mandatory=$true)]
		[String] $server, 

		[Parameter(Mandatory=$true)]
		[String] $apiKey,

		[Parameter(Mandatory=$true)]
		[String]$projectName,

		[Parameter(Mandatory=$false)]
		[Object] $psCredential,

		#TODO:NIKO
		[Parameter(Mandatory=$false)]
		[String]$role,

		#TODO:NIKO
		[Parameter(Mandatory=$false)]
		[String]$environment
	)

	$project = Octopus-GetProject $server $apiKey $projectName $psCredential
	if ($project -ne $null)
	{
		return Octopus-Get $server $project.Links.Variables $apiKey $psCredential
	}

	return $null
}

#Machines
#Environments
#Releases
#Deployments

Export-ModuleMember Octopus-Get,
					Octopus-GetProjects,
					Octopus-GetEnvironments,
					Octopus-GetProject,
					Octopus-GetEnvironment,
					Octopus-GetProjectSteps,
					Octopus-GetProjectVariables