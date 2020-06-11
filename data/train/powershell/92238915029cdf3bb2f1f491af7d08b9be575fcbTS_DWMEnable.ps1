# Copyright © 2008, Microsoft Corporation. All rights reserved.


. .\CL_LoadAssembly.ps1

Import-LocalizedData -BindingVariable localizationString -FileName CL_LocalizationData

Write-DiagProgress -activity $localizationString.DWM_progress

[bool]$enabled = $false

LoadAssemblyFromPath("DesktopWindowsMgmt.dll")
$enabled = [Microsoft.Windows.Diagnosis.SystemInfo.DesktopWindowsMgmt.DesktopWindowsManager]::IsEnabled()

if(-not($enabled))
{
    Update-DiagRootCause -id "RC_DWMEnable" -detected $true
} else {
    Update-DiagRootCause -id "RC_DWMEnable" -detected $false
}

return $enabled
