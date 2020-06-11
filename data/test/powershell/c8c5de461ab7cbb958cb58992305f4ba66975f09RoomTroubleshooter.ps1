
<#
Script Name:    RoomTroubleshooter.ps1
Author:         Cory Knox
Email:          github.powershell@knoxy.ca
Version:        0.0.1
Raison d'etre:  Have a series of boardrooms that we need to access computers in. This translates a room name/number to the computer name. Also allows access to the room's panel.
				This is a re-write of the AutoIt script that worked prior to new XPANELs.
Requirements:   ShowUI (cloned from: https://github.com/show-ui/ShowUI)
                PowerShell 3 (I think, only tested on PowerShell 5 Windows 7/10)
                Elevation *not* required
                User running script must have permissions to access XPANEL locations
				TightVNC must be installed.
ToDo:            
#>
Import-Module ShowUI

#Variables section
$vncPath = "C:\Program Files\TightVNC\"
$vncExe = "tvnviewer.exe"
$vncPassword = 'Password'
if (test-path .\configs\rooms.csv) {
	$rms = Import-Csv .\configs\rooms.csv
}

New-Grid -Columns 4 -Children {
	New-Label -Content "Room:"
	new-combobox -Items {
		foreach ($rm in $rms) {
			New-ComboBoxItem "$($rm.rmnum)" -Name "RoomNumber"
		}
	} -Column 1
	New-Button -Content "Launch VNC" -On_Click {
		Get-ParentControl | Set-UIValue
		write-host $RoomNumber
	} -Column 2
	New-Button -Content "Launch XPANEL" -On_Click {
		write-host $RoomNumber
	} -Column 3
}  -AsJob