# FarmWorks.ps1 
#
# Paul Hinsberg, UNR IT , Aug 14, 2013 
#
# This script will perform vaious functions on XenApp farms and VMSphere systems. 
# 
# Note that several snapins must be present: 
# 	Citrix Snapins - Citrix SDK 
# 	VMWare Snapins - VMWare Power CLI 
# 
# The script is intended to run from the c:\scripts folder of a server in the Citrix farm that you 
# would like to manage. Note that the system running the script will be immune to the effects. 
#
# The STARTEM and CHECK functions assume that a previous shutdown was executed and are expecting a
# list of servers, c:\scripts\Serverstoreboot.txt to exist.  If there is no list, these functions will 
# generate on from based on the farm that the server it is run from is in. 
# 
#

If ($args[0] -eq "reboot" ) { Reboot ; break } 

$sourcecomputer = (Get-ChildItem -Path env:computername).value 

Write-host "*** On the Menu ***" 
Write-host 
Write-host "1) Shutdown servers in a farm" 
Write-host "2) Reboot servers in a farm" 
Write-host "3) Check on powerstate of servers" 
Write-host "4) Start the servers in a list of" 
Write-host 
Write-host 
	
$a=Read-Host -Prompt "Please enter you select: " 
switch ($a) { 
	1 { ShutdownEm ; break } 
	2 { RebootEm ; break } 
	3 { CheckEm ; break } 
	4 { StartEm ; Break } 
	default { HelpExitEm ; Break } 
} 


Function ShutdownEm { 
If (Test-Path c:\Scripts\Serverstoreboot.txt) { 
	Remove-Item -Path c:\Scripts\Serverstoreboot.txt 
}

foreach ($server in (Get-XAServer)) { 
	If ($server -ne $sourcecomputer) { 
		Out-File -FilePath C:\Scripts\Serverstoreboot.txt -inputObject $server.ServerName -Append
	}
}
$servers= Get-content C:\Scripts\Serverstoreboot.txt
$servers
write-host "Number of servers to be SHUTDOWN: " $servers.Length 

$a=Read-Host -Prompt "Shall we continue with the shutdown of these servers? (y/N)" 
If ($a -eq "y") { 
	foreach ($server in (Get-Content -Path C:\Scripts\Serverstoreboot.txt)) { 
		# Stop-Computer -ComputerName $server -Force 
		Write-Host "I would have shutdown " $server 
	} 
	}
else { 
	Write-Host "Nothing more will be done." 
	}
Write-Host "Done processing." 
}

Function RebootEm { 
If (Test-Path c:\Scripts\Serverstoreboot.txt) { 
	Remove-Item -Path c:\Scripts\Serverstoreboot.txt 
}

foreach ($server in (Get-XAServer)) { 
	If ($server -ne $sourcecomputer) { 
		Out-File -FilePath C:\Scripts\Serverstoreboot.txt -inputObject $server.ServerName -Append
	}
}
$servers= Get-content C:\Scripts\Serverstoreboot.txt

if ($args[0] -ne "reboot")  {
	$servers
	write-host "Number of servers to be rebooted: " $servers.Length 

	$a=Read-Host -Prompt "Shall we continue with the reboot of these servers? (y/N)" 

	If ($a -eq "y") { 
		foreach ($server in (Get-Content -Path C:\Scripts\Serverstoreboot.txt)) { 
			# Stop-Computer -ComputerName $server -Force 
			Write-Host "I would have shutdown " $server 
		} 
	}
	else { 
		Write-Host "Nothing more will be done." 
	}
	Write-Host "Done processing." 
}
else { 
	foreach ($server in (Get-Content -Path C:\Scripts\Serverstoreboot.txt)) { 
			# Restart-Computer -ComputerName $server -Force 
			Write-Host "I would have shutdown " $server 
	}
}
}

Function CheckEm { 

If (Test-Path c:\Scripts\Serverstoreboot.txt) { } 
else { 
	foreach ($server in (Get-XAServer)) { 
		If ($server -ne $sourcecomputer) { 
			Out-File -FilePath C:\Scripts\Serverstoreboot.txt -inputObject $server.ServerName -Append
		}
	}
}

Connect-VIServer -Server sickbay -NotDefault

foreach ($server in (Get-content C:\Scripts\Serverstoreboot.txt)) { 
	Get-VM -Name $server 
}

}  #End Function

Function StartEM { 

}

Function HelpExitEm { 
   Write-Host " Thank you for using this script." 
   Write-Host 
   Write-Host " If you need to reboot servers in a Xen App farm the syntax is './FarmWorks.ps1 reboot'."
   Write-Host " This will avoid the menu structure and allows for scheduling of reboots of a farm." 
   Write-Host " Note that the script will default to rebooting the servers in the farm of the server " 
   Write-Host " that the script was run from. Excluding the server that the scripts is currently running on."
   
}

