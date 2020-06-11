foreach ($targetou in 'Billing','Customer Support','IT')
{

"Processing information for OU $targetou"
$DomainRootPath='LDAP://OU='+$targetou+',OU=Users,OU=PATH,OU=TO,DC=YOUR,DC=DOMAIN'
$adsearch = New-Object DirectoryServices.DirectorySearcher([adsi]$DomainRootPath)
$adsearch.filter = "(objectclass=user)"
$adsearch.PropertiesToLoad.AddRange(@("name"))
$adsearch.PropertiesToLoad.AddRange(@("lastLogon"))
$adsearch.PropertiesToLoad.AddRange(@("givenName"))
$adsearch.PropertiesToLoad.AddRange(@("SN"))
$adsearch.PropertiesToLoad.AddRange(@("DisplayName"))
$adsearch.PropertiesToLoad.AddRange(@("extensionAttribute1"))
$adsearch.PropertiesToLoad.AddRange(@("extensionAttribute2"))
$adsearch.PropertiesToLoad.AddRange(@("comment"))
$adsearch.PropertiesToLoad.AddRange(@("title"))
$adsearch.PropertiesToLoad.AddRange(@("mail"))
$adsearch.PropertiesToLoad.AddRange(@("userAccountControl"))
$adsearch.Container
$users = $adsearch.findall()
$users.Count
$report = @()

foreach ($objResult in $users)
{
$objItem = $objResult.Properties
$temp = New-Object PSObject
$temp | Add-Member NoteProperty name $($objitem.name)
$temp | Add-Member NoteProperty title $($objitem.title)
$temp | Add-Member NoteProperty mail $($objitem.mail)
$temp | Add-Member NoteProperty displayname $($objitem.displayname)
$temp | Add-Member NoteProperty extensionAttribute1 $($objitem.extensionattribute1)
$temp | Add-Member NoteProperty extensionAttribute2 $($objitem.extensionattribute2)
$temp | Add-Member NoteProperty givenname $($objitem.givenname)
$temp | Add-Member NoteProperty sn $($objitem.sn)
$temp | Add-Member NoteProperty useraccountcontrol $($objitem.useraccountcontrol)
$report += $temp
}

$csvfile="C:\AD-"+$targetou+".csv"
$report | export-csv -notypeinformation $csvfile
"Wrote file for $targetou"
}