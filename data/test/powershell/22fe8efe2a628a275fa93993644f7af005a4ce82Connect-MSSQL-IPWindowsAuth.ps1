## =====================================================================
## Title       : Connect-MSSQL-IPWindowsAuth
## Description : Connect to SQL Server using IP address, instance and 
##                  Windows authentication
## Author      : Idera
## Date        : 1/28/2009
## Input       : -ipAddress < xxx.xxx.xxx.xxx | xxx.xxx.xxx.xxx\instance >
##               -verbose 
##               -debug	
## Output      : Database names and owners
## Usage			: PS> .\Connect-MSSQL-IPWindowsAuth -ipAddress 127.0.0.1 -verbose -debug
## Notes 		: 
##	Tag			: MSSQL, connect, IP, Windows Authentication
## Change Log	: Revised SMO Assemblies
## =====================================================================
 
param
(
  	[string]$ipAddress = "127.0.0.1",
	[switch]$verbose,
	[switch]$debug
)

function main()
{
	if ($verbose) {$VerbosePreference = "Continue"}
	if ($debug) {$DebugPreference = "Continue"}
	Connect-MSSQL-IPWindowsAuth $ipAddress
}

function Connect-MSSQL-IPWindowsAuth($ipAddress)
{
	trap [Exception] 
	{
		write-error $("TRAPPED: " + $_.Exception.Message);
		continue;
	}
	
	# Load-SMO assemblies
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.Management.Common" );
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.SmoEnum" );
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" );
	[void][reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.SmoExtended " );
	
	# Instantiate a server object
	# TIP: using PowerShell "`" to signify line continuation
	Write-Debug "Creating SMO Server object..."
	
	$Smo = "Microsoft.SqlServer.Management.Smo."
	$smoServer = new-object ($Smo + 'server') "$ipAddress"

	# Use Windows Authentication by setting LoginSecure to TRUE
	Write-Debug "Setting Windows Authentication mode..."
	$smoServer.ConnectionContext.set_LoginSecure($TRUE)
	
	# Clear the screen
	# TIP: cls will clear the PowerShell console
	cls
	Write-Host Your connection string contains these values:
	Write-Host
	$smoServer.ConnectionContext.ConnectionString.Split(";")
	Write-Host
	
	# List information about the databases
	Write-Host "Databases on " $ipAddress
	Write-Host
	foreach ($db in $smoServer.Databases) 
	{
		write-host "Database Name : " $db.Name
		write-host "Owner         : " $db.Owner
		write-host
	}
}

main