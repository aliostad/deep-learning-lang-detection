#Get-InfoPathForm
#This script will return the local form template object 
#[Microsoft.Office.InfoPath.Server.Administration.FormTemplate]
#from the local MOSS Farm 
#$null is return if form is not loaded in Farm 
#Parameter 
#FormName needs to be full URN name 
#ex: urn:schemas-microsoft-com:office:infopath:NewBusinessAdnd:-myXSD-2008-08-17T06-04-10

param([string] $formName = $(throw 'The full form URN name is required')) 

#load needed assemblies 

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Administration") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.InfoPath.Server") | Out-Null

#get the local Farm 
$spfarm = [Microsoft.SharePoint.Administration.SPFarm]::local

#get the form service 
$lsf = $spfarm.services | ?{$_.TypeName -eq "Forms Service"}

#get form 
$xsn = $lsf.Formtemplates | ?{$_.Name -eq $formName}

return $xsn