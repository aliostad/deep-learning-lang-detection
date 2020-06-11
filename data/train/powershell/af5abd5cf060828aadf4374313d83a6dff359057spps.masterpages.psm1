#----------------------------------------------------------------------------- 
# Filename : spps.masterpages.ps1 
#----------------------------------------------------------------------------- 
# Author : Jeffrey Paarhuis
#----------------------------------------------------------------------------- 
# Contains methods to manage master pages.

function Set-CustomMasterPage
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string]$masterFile
	)

    $masterUrl = Join-Parts -Separator '/' -Parts $Spps.Site.ServerRelativeUrl, "/_catalogs/masterpage/$masterFile"

    $web = $Spps.Web

    # Update Site Master Page
    Write-Host "Master page wordt ingesteld op $masterFile" -foregroundcolor black -backgroundcolor yellow
	$web.CustomMasterUrl = $masterUrl

    $web.Update()
    $Spps.ExecuteQuery()

}


function Set-MasterPage
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
		[string]$masterFile
	)

    $masterUrl = Join-Parts -Separator '/' -Parts $Spps.Site.ServerRelativeUrl, "/_catalogs/masterpage/$masterFile"

    $web = $Spps.Web

    # Update Site Master Page
	Write-Host "System master page wordt ingesteld op $sysMasterFile" -foregroundcolor black -backgroundcolor yellow
    $web.MasterUrl = $masterUrl

    $web.Update()
    $Spps.ExecuteQuery()

}