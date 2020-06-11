param($url="http://shp-volgd/ISS",$what="Весь персонал РДУ")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists["Документы"]
$list.Items | ? {$_["Для подразделений"] -like "*$what*"} | % {$_["Для подразделений"] = ";#Весь персонал РДУ;#ОДС;#СЭР;#СЭРБиР;#СРЗА;#ОПРиТП;#ОСР;#СЭПАК;#СТМС;#АПО;#ОАХО;#ОБУЭ;#ТА;#"; $_.Update()}