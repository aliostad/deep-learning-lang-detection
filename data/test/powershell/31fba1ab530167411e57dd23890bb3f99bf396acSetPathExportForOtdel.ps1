param($otdel,$path,$url="http://shp-volgd/ISS")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists["Документы"]
$list.Items | ? {$_["Для подразделений"] -like "*$otdel*"} | % {$_["Путь экспорта"] = $path; $_.Update()}