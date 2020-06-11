param($url="http://shp-volgd/ISS")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists["Документы"]
$cnt = 0
$m = New-Object System.Text.RegularExpressions.Regex("^(?<ID>\d\d.+?) (?<Name>\w\w.+)$")
$list.Items | % {$ma = $m.Match($_["Имя"]); if ($ma.Success) {$_["Имя"] = $ma.Groups["Name"].Value.Trim(); $_["Номер"] = $ma.Groups["ID"].Value; $_.Update(); $cnt+=1}}
$cnt