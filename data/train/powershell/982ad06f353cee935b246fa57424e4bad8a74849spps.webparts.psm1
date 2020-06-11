#----------------------------------------------------------------------------- 
# Filename : spps.webparts.ps1 
#----------------------------------------------------------------------------- 
# Author : Jeffrey Paarhuis
#----------------------------------------------------------------------------- 
# Contains methods to manage web parts

function Add-Webpart
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, Position=1)]
	    [string]$pageUrl,
		
		[Parameter(Mandatory=$true, Position=2)]
	    [string]$zone,
		
		[Parameter(Mandatory=$true, Position=3)]
	    [int]$order,
		
		[Parameter(Mandatory=$true, Position=4)]
	    [string]$webPartXml
	)
    
    Submit-CheckOut $pageUrl

	$targetPath = Join-Parts -Separator '/' -Parts $spps.Web.ServerRelativeUrl, $pageUrl
	$page = $spps.Web.GetFileByServerRelativeUrl($targetPath)
    $webPartManager = $page.GetLimitedWebPartManager([Microsoft.SharePoint.Client.WebParts.PersonalizationScope]::Shared)
    $replacedWebPartXml = Convert-StringVariablesToValues -string $webPartXml
	$wpd = $webPartManager.ImportWebPart($replacedWebPartXml)
    $webPart = $webPartManager.AddWebPart($wpd.WebPart, $zone, $order);
    
    $spps.ExecuteQuery()

    Submit-CheckIn $pageUrl

	Write-Host "Web part succesfully added to the page $pageUrl" -foregroundcolor black -backgroundcolor green
}