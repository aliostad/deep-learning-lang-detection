########################################################
# This script copy the plugins' files into the main
# application's plugins directory. 
########################################################
# Variables:
########################################################
Param ($releaseMode = "debug")
$separator = "======================================================================================================="
$executingPath = Split-Path($MyInvocation.MyCommand.Path)
$prj = "$executingPath\..\..\src"
$root = "$prj\Plugins"
########################################################
# Functions:
########################################################
function GetDirectory([string] $pluginName)
{
	return "$prj\View\Probel.NDoctor.View.Core\bin\$releaseMode\Plugins\$pluginName"
}
function CopyPluginFiles([string] $pluginName)
{
	Write-Host -NoNewline "Copying files of '$pluginName'... "
	$directory     = GetDirectory($pluginName)
	
	$pluginDll     = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\Probel.NDoctor.Plugins.$pluginName.dll"
	
	$rsxHelper     = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\fr\Probel.Helpers.resources.dll"
	$rsxDal        = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\fr\Probel.NDoctor.Domain.DAL.resources.dll"
	$rsxPlugin     = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\fr\Probel.NDoctor.Plugins.$pluginName.resources.dll"
	$rsxCore       = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\fr\Probel.NDoctor.View.Core.resources.dll"
	$rsxViewPlugin = "$root\Probel.NDoctor.Plugins.$pluginName\bin\$releaseMode\fr\Probel.NDoctor.View.Plugins.resources.dll"
	
	mkdir $directory      -Force | Out-Null
	mkdir "$directory\fr" -Force | Out-Null
	
	copy "$pluginDll" "$directory\"       
	copy "$rsxHelper" "$directory\fr"     
	copy "$rsxDal" "$directory\fr"        
	copy "$rsxPlugin" "$directory\fr"     
	copy "$rsxCore" "$directory\fr"       
	copy "$rsxViewPlugin" "$directory\fr" 
	
	"Done"
}
########################################################
#Main:
########################################################
clear
$separator
"project: $prj"
"root   : $root"
"mode   : $releaseMode"
$separator

CopyPluginFiles("UserSession");
CopyPluginFiles("PatientSession");
CopyPluginFiles("PrescriptionManager");
CopyPluginFiles("Administration");
CopyPluginFiles("Authorisation");
CopyPluginFiles("PictureManager");
CopyPluginFiles("BmiRecord");
CopyPluginFiles("PathologyManager");
CopyPluginFiles("PatientData");
CopyPluginFiles("DbConvert");
CopyPluginFiles("FamilyViewer");
CopyPluginFiles("MeetingManager")
CopyPluginFiles("DebugTools")
CopyPluginFiles("PatientOverview")
CopyPluginFiles("RescueTools")

$currentPlugin = "MedicalRecord"
CopyPluginFiles($currentPlugin)
$dir = GetDirectory($currentPlugin)                       
copy "$root\Probel.NDoctor.Plugins.$currentPlugin\bin\$releaseMode\ICSharpCode.AvalonEdit.dll" "$dir"                      


""
"Script executed"
