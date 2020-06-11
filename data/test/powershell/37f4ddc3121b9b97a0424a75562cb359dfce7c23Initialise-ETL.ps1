	param
	(
		$workingDirectory, 
		$deployConfig, 
		$deploymentPackages,
		$server, 
		$serviceEndpoints,
		$debugMode
	)
	$debugPreference = $debugMode
	
	$actions = @()
	
	$isSqlHost  = $server.role -icontains "sql"
	
	if ($isSqlHost)
	{
		$resourceDirectory = "c:\temp\deploymentResources"
		
		$etlPublishingSql = Join-Path $resourceDirectory "ETL\Publish-Etl.sql"
		$etlPackages  = Join-Path $deployConfig.buildArtefacts "Databases\Etl"
		
		Write-Debug "ETL Packages  => $etlPackages"
		Write-Debug "ETL Publisher => $etlPublishingSql";
		
		if (!(Test-Path $etlPublishingSql ))
		{
			throw "ETL $etlPublishingSql script not found"
			exit;
		}
		
		if (!(Test-Path $etlPackages ))
		{
			throw "$etlPackages packages not found"
			exit;
		}
		
		if (Test-Path "C:\ETL")
		{
			Write-Debug "Removing the ETL directory"
			Remove-Item "C:\ETL" -recurse -force -ErrorAction SilentlyContinue | Out-Null
		}

		Write-Debug "Creating a new ETL directory"
		New-Item -type Directory "C:\ETL"  | Out-Null
		
		Write-Debug "Copying packages over to server"
		Copy-Item "$etlPackages\*.dtsx" "C:\ETL\" -force 
		
		$actions += createAction "ETL packages copied"
		
		if ( Get-PSSnapin -Registered | where {$_.name -eq 'SqlServerProviderSnapin100'} ) 
		{ 
			if( !(Get-PSSnapin | where {$_.name -eq 'SqlServerProviderSnapin100'})) 
			{  
				Add-PSSnapin SqlServerProviderSnapin100 | Out-Null 
			} ;  
			if( !(Get-PSSnapin | where {$_.name -eq 'SqlServerCmdletSnapin100'})) 
			{  
				Add-PSSnapin SqlServerCmdletSnapin100 | Out-Null 
			} 
		} 
		else 
		{ 
			if( !(Get-Module | where {$_.name -eq 'sqlps'})) 
			{  
				Import-Module 'sqlps' –DisableNameChecking | Out-Null
				Set-Location C:\temp
			} 
		} 

		[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
		[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlEnum")
		[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
		[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
		[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended")
		
		$etlScript = Get-Content $etlPublishingSql | Out-String
		
		Invoke-Sqlcmd -Query $etlScript -ServerInstance "localhost" -Database "master" -U "sa" -Password "r9a8b8k1$" -OutputSqlErrors $true | Write-Host

	}
		 
	
	Write-Output $actions
