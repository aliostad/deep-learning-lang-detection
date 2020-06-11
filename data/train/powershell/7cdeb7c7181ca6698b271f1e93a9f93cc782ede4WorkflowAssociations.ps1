if ($args.Count -eq 0)
{
	write-host "siteurl parameter is missing. Please provide the Url of a site collection as a parameter" -foregroundcolor red -backgroundcolor black
	exit
}

Function Show-WorkflowAssociation($workflowassociation) { 
	write-host "Web: "  -nonewline; write-host $_.ParentWeb.Url
	write-host "List: "  -nonewline; write-host $_.ParentList.Title; 
	write-host "Soap Xml:"; write-host $_.SoapXml
}

[System.Reflection.Assembly]::LoadWithPartialName(”Microsoft.SharePoint”) 

$mysite=new-object Microsoft.SharePoint.SPSite($args[0]) 

$mysite.Allwebs | foreach { $_.Lists | foreach { $_.WorkflowAssociations | foreach { Show-WorkflowAssociation($_) } } }

















