<#
.SYNOPSIS
    Sample showing use of SMO and PowerShell
.DESCRIPTION
    Uses SMO objects to find available SQL Servers
.NOTES
    File Name  : Get-SQLServers.ps1
	Author     : Thomas Lee - tfl@psp.co.uk
	Requires   : PowerShell V2 CTP3
.LINK
    http://www.pshscripts.blogspot.com
#>

##
# Start of script
##

# Load the SMO objects
$load = [reflection.assembly]::LoadWithPartialName( "Microsoft.SqlServer.Smo" )

# Derive the SMO Application Object
$smo = [Microsoft.SqlServer.Management.Smo.SmoApplication]

# Get available SQL Servers and display them
$SQLServers = $smo::EnumAvailableSqlServers("Cookham8.cookham.net");
"SQL Servers found:"
$SQLServers
# End of script