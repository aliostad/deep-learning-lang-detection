param($url="http://shp-volgd/iss",$lst="Документы",$where="Подразделение",$who="СЭРБиП",$what="СЭРБ")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists[$lst]
$list.Items | ? {$_[$where] -like "*$who*"} | % {$_[$where] = ($_[$where]).Replace($who,$what); $_.Update()}