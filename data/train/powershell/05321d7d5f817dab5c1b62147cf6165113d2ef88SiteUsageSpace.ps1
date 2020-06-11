param($url="http://shp-volgd")
$cr = new-object System.Net.NetworkCredential("MakievskyAV", "6h42VP", "oduyu.so")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$site.C
$su = $site.Usage.Storage / 1Mb
$sout = "ScriptRes:"
if ($su -gt 6000)
{$sout += "Bad:"}
else
{$sout += "Ok:"}
$sout += [Decimal]::Round($su)
$sout
#$sout += "{0:n2}" -f ($su * 1kb)