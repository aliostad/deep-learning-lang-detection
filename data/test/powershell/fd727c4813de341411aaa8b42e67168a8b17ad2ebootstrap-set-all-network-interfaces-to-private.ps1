# Don't show new network location dialog. These are all the techniques I could find. They don't work :(
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Name NewNetworkWindowOff -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network" -Name NetworkLocationWizardHideWizard -Value 1 -Type DWord -Force
New-Item         -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Network" -Name NwCategoryWizard -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Network\NwCategoryWizard" -Name Show -Value 0 -Type DWord -Force

$interface = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}'))
$interface.GetNetworkConnections() | Foreach-Object { $_.GetNetwork().SetCategory(1) }
