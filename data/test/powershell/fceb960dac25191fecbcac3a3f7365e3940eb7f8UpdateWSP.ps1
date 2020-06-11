
################################################################################
# UBC FOM Intranet deployment script
################################################################################
 
#include file
. "C:\Deployment\Scripts\includeFunctions.ps1"
. "C:\Deployment\Scripts\GlobalVariables.ps1"

. "C:\Deployment\Scripts\Miguel\includeFunctions.ps1"
. "C:\Deployment\Scripts\Miguel\GlobalVariables.ps1"

# set log file
SetLogFile

#load the SharePoint snapin
cls
loadSnapins

#load assemblies
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")


$wspName = "UBCFOM.CalEventsAnnounceWebPart.wsp"
$wsp = $wspDirectory + "\" + $wspName

Update-SPSolution -identity $wspName -LiteralPath $wsp -GACDeployment -force

$wspName = "UBCFOMBranding.wsp"
$wsp = $wspDirectory + "\" + $wspName

Update-SPSolution -identity $wspName -LiteralPath $wsp -GACDeployment -force

