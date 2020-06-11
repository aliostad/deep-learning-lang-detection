param($wfname = "Контроль сроков исполнения задач", $listname = "Задачи", $url="http://shp-volgd/RegZadach")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$site = new-object Microsoft.SharePoint.SPSite("$url")
$web = $site.OpenWeb()
$list = $web.Lists[$listname]
#$list.WorkflowAssociations
$wf = $list.WorkflowAssociations | ? {$_.Name -eq $wfname}
$list.Items | % {$site.WorkflowManager.StartWorkflow($_,$wf,$wf.AssociationData,$true)}