# Import StoreFront API Modules
& "c:\program files\Citrix\receiver storefront\scripts\ImportModules.ps1"

# Set Powershell Compatibility Mode
Set-StrictMode -Version 2.0

# Any failure is a terminating failure.
$ErrorActionPreference = 'Stop'

#create logging folder
$logpath = "C:\@inf\winbuild\logs\citrix"
mkdir $logpath -force

# Set Paths
$RegProp = Get-ItemProperty -Path HKLM:\SOFTWARE\Citrix\DeliveryServices -Name InstallDir
$ScriptDir = $RegProp.InstallDir+"\Scripts"
$InstallProp = Get-ItemProperty -Path HKLM:\SOFTWARE\Citrix\DeliveryServicesManagement -Name InstallDir
$InstallDir = $InstallProp.InstallDir

[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Authentication.Extensions.CitrixAGBasic.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Roaming.CreateRoamingServiceExtension.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Roaming.GatewaysScopeNode.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Roaming.StoreExtensions.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Stores.Model.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.Admin.Utils.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.ServiceRecords.Admin.RoamingModel.dll")
[Reflection.Assembly]::LoadFrom("$InstallDir\Citrix.DeliveryServices.ServiceRecords.Admin.StoreServiceRecordModel.dll")
