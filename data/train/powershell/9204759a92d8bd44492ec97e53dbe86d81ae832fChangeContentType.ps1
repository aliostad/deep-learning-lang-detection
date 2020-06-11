param($url="http://shp-volgd/ShareDoc")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists["Телефонный справочник"]
$ctt = $list.ContentTypes["Телефон"]
$cnt = 0
$list.Items | ? {$_["ContentTypeId"] -ne $ctt.ID.ToString()} | % {$_["ContentType"] = $ctt; $_.Update(); $cnt+=1}
$cnt