# Taken from: http://blogs.msdn.com/b/adpowershell/archive/2009/08/18/active-directory-powershell-to-manage-sites-and-subnets-part-3-getting-site-and-subnets.aspx

## Get a specified Active Directory Site.    
$siteName =  "Default-First-Site-Name"
$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
$siteContainerDN = ("CN=Sites," + $configNCDN)
$siteDN = "CN=" + $siteName + "," + $siteContainerDN
Get-ADObject -Identity $siteDN -properties *


##  Get all Active Directory Sites (and fetch relevant properties)

$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
$siteContainerDN = ("CN=Sites," + $configNCDN)
Get-ADObject -SearchBase $siteContainerDN -filter { objectClass -eq "site" } -properties "siteObjectBL", "location", "description" | select Name, Location, Description


##  Get all Servers in a specified Active Directory site.

$siteName =   "Default-First-Site-Name"
$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
$siteContainerDN = ("CN=Sites," + $configNCDN)
$serverContainerDN = "CN=Servers,CN=" + $siteName + "," + $siteContainerDN
Get-ADObject -SearchBase $serverContainerDN -SearchScope OneLevel -filter { objectClass -eq "Server" } -Properties "DNSHostName", "Description" | Select Name, DNSHostName, Description


##  Get all Subnets in a specified Active Directory site.

$siteName =  "Default-First-Site-Name"
$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
$siteContainerDN = ("CN=Sites," + $configNCDN)
$siteDN = "CN=" + $siteName + "," + $siteContainerDN
$siteObj = Get-ADObject -Identity $siteDN -properties "siteObjectBL", "description", "location" 
foreach ($subnetDN in $siteObj.siteObjectBL) {
    Get-ADObject -Identity $subnetDN -properties "siteObject", "description", "location" 
}


##  Print a list of site and their subnets

$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
$siteContainerDN = ("CN=Sites," + $configNCDN)
$siteObjs = Get-ADObject -SearchBase $siteContainerDN -filter { objectClass -eq "site" } -properties "siteObjectBL", name
foreach ($siteObj in $siteObjs) {
    $subnetArray = New-Object -Type string[] -ArgumentList $siteObj.siteObjectBL.Count
    $i = 0
    foreach ($subnetDN in $siteObj.siteObjectBL) {
        $subnetName = $subnetDN.SubString(3, $subnetDN.IndexOf(",CN=Subnets,CN=Sites,") - 3)
        $subnetArray[$i] = $subnetName
        $i++
    }
    $siteSubnetObj = New-Object PSCustomObject | Select SiteName, Subnets
    $siteSubnetObj.SiteName = $siteObj.Name
    $siteSubnetObj.Subnets = $subnetArray
    $siteSubnetObj
}


## Print the site name of a Domain Controller

$dcName = (Get-ADRootDSE).DNSHostName   ## Gets the name of DC to which this cmdlet is connected
(Get-ADDomainController $dcName).Site
