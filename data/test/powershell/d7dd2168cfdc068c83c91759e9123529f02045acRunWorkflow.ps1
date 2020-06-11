param($wfname = "Контроль регулярных задач", $listname = "Описание задач", $url="http://shp-volgd/RegZadach")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists[$listname]
$wf = $list.WorkflowAssociations | ? {$_.Name -eq $wfname}
$list.Items | % {$site.WorkflowManager.StartWorkflow($_,$wf,$wf.AssociationData,$true)}