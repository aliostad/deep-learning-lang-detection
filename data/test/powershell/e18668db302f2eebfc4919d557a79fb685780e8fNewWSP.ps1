
################################################################################
# UBC FOM Intranet deployment script
################################################################################
 
#include file
. "C:\Scripts\includeFunctions.ps1"
. "C:\Scripts\GlobalVariables.ps1"

#. "C:\_Code_Ben\UBC FOM Intranet\UBC FOM Intranet\Deployment\Scripts\includeFunctions.ps1"
#. "C:\_Code_Ben\UBC FOM Intranet\UBC FOM Intranet\Deployment\Scripts\GlobalVariables.ps1"

# set log file
SetLogFile

#load the SharePoint snapin
cls
loadSnapins

#load assemblies
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")


$wspName = "FOMMeeting.wsp"
$wspDirectory = "C:\WSP"
$wsp = $wspDirectory + "\" + $wspName
Add-SPSolution $wsp           
Install-SPSolution -identity $wspName -GACDeployment -force -WebApplication https://test.mednet.med.ubc.ca
            