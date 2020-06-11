# Copyright © 2008, Microsoft Corporation. All rights reserved.


. .\CL_LoadAssembly.ps1
. .\CL_Utility.ps1

Import-LocalizedData -BindingVariable localizationString -FileName CL_LocalizationData

Write-DiagProgress -activity $localizationString.powerPolicySettingResolve_progress

LoadAssemblyFromNS "System.Windows.Forms"

[string]$balancedGuid = "381b4222-f694-41f0-9685-ff5bb260df2e"
[string]$powercfgCmd = GetSystemPath "Powercfg.exe"

& $powercfgCmd /setActive $balancedGuid

[string]$cmdOutput = & $powercfgCmd "/GETACTIVESCHEME"
$lineOn = [System.Windows.Forms.SystemInformation]::PowerStatus.PowerLineStatus

New-Object -TypeName System.Management.Automation.PSObject | Select-Object @{Name=$localizationString.powerSource;Expression={ConvertTo-PowerSourceName $lineOn}},@{Name=$localizationString.modifiedSetting;Expression={Get-PowerPolicyInfo $cmdOutput}} | Convertto-Xml | Update-DiagReport -id ModifiedPowerPolicySetting -name $localizationString.powerPolicy_name -description $localizationString.powerPolicy_Description -Verbosity informational