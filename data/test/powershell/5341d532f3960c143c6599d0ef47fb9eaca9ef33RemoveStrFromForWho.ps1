param($url="http://shp-volgd/ISS")
param($what="Руководство")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists["Документы"]
$list.Items | ? {$_["Для подразделений"] -like "*$what*"} | % {$_["Для подразделений"] = $_["Для подразделений"].Replace(";#$what",""); $_.Update()}