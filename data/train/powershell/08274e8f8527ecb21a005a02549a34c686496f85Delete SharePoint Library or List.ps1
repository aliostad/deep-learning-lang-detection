# Removing libraries that don’t allow deletion in SharePoint

# Scenarios where you may see a library like this would be in a site with the publishing feature enabled. For the case of libraries like the Images library, Documents library or even the Site Collection Documents library it is simply not possible to remove them from the lists settings page or the manage content and structure tool.

# The reason for this is that on creation the library has been set as False for the property AllowDeletion.

if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
	Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
$spWeb = Get-SPWeb -identity "http://smsk01we32u"  
$list = $spWeb.Lists["ssef"]
$list.AllowDeletion = $True
$list.Update()

# $list.Delete()