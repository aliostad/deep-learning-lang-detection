#New-ADSite.ps1

$sitename="London"
$subnetip="192.168.100.0/24"
$loc="LON"

$forest=[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()

#creating a site
$context=New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext "forest",$forest.name
$site=New-Object System.DirectoryServices.ActiveDirectory.ActiveDirectorySite $context,$sitename

#define a location value if you'd like
$site.location=$loc
$site.Save()

#create subnet and add to site
$subnet=New-Object System.DirectoryServices.ActiveDirectory.ActiveDirectorySubnet $context,$subnetip,$sitename

#define a location value if you'd like
$subnet.location=$loc
$subnet.save()

#get main sitelink object
$link=$forest.sites[0].sitelinks[0]

#add new site to sitelink
$link.sites.add($site) | Out-Null
$link.save()

#refresh 
$forest=[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$forest.sites
