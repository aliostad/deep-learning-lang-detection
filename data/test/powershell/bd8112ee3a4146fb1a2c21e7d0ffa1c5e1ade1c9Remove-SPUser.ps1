
function RemoveUser([string]$Site, [string]$SiteCollection, [string]$User) {

	# GAC

	[System.Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | Out-Null

	# Connect To Sharepoint

	$SPSite = New-Object Microsoft.SharePoint.SPSite($Site)
	$OpenWeb = $SPSite.OpenWeb($SiteCollection)

	# Check if User Exists in Site

	if ($OpenWeb.SiteUsers | Where {$_.LoginName -eq $User}) {
		$User = $OpenWeb.SiteUsers | Where {$_.LoginName -eq $User}
		$OpenWeb.SiteUsers.Remove($User)

		Write-Host "User: $User Successfully Removed from Site: $Site/$SiteCollection"
	} else {
	Write-Host "User: $User Does not exist on Site: $Site/$SiteCollection"
	}
	$SPSite.Dispose()
	$OpenWeb.Dispose()
}
