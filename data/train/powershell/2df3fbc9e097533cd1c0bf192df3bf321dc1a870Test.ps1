###################################################################################
# LabLauncher Test-Code
# Stefan Wehrli <stwehrli@gmail.com>
# 13jan2013
###################################################################################

# Start LabLauncher GUI Application
Start-LabLauncher

# Select computers
Select-Pool

# Connect
Register-Pool localhost

# Hide/Show/Enable/Disable
Invoke-Pool {Show-LabLauncher}
Invoke-Pool {Hide-LabLauncher}
Invoke-Pool {Disable-LabLauncher}
Invoke-Pool {Enable-LabLauncher}

# Browser
Invoke-Pool {Show-Browser "www.google.ch" }
sleep 5
Invoke-Pool {Hide-Browser }

Invoke-Pool {Send-Browser "www.ethz.ch" 5}

#WaitForm
Invoke-Pool {Show-WaitFrom }
sleep 5
Invoke-Pool {Hide-WaitForm }

Invoke-Pool {Send-WaitForm "Can you see this?" 5 }
Invoke-Pool {Send-WaitForm "" 5 }

#AuthForm
Invoke-Pool {Show-AuthForm}
sleep 5
Invoke-Pool {Hide-AuthForm}

###################################################################################
#Devices

#Beeping
Invoke-Pool {$LabLauncher.WinApi.Beep()}

Invoke-Pool { 
  function BeepMe { 
    for($i = 1; $i -le 8; $i++) {
      $LabLauncher.WinApi.Beep($i*250, 200)
    }
  }
}

Invoke-Pool BeepMe

# Mouse Movement
# Does not work, need to pipe $j into remote host
for([int]$i=1; $i -lt 20; $i++) {
  $j = $i * 50
  invoke-Pool { $LabLauncher.WinApi.MouseXY($j, $j) }
  sleep -milliseconds 300
}

#Mouse
Invoke-Pool { Disable-Mouse }
sleep 5
Invoke-Pool { Enable-Mouse }

#Keyboard
Invoke-Pool { Disable-Keyboard }
sleep 5
Invoke-Pool { Enable-Keyboard }

#KioskFilter
Invoke-Pool { Enable-KioskFilter }
sleep 5
Invoke-Pool { Disable-KioskFilter }

#Volume (not functional yet)
#Invoke-Pool { Set-Volume 100 }

###################################################################################
# Messages
Invoke-Pool {Send-Notification "You won a million dollars!"}

###################################################################################
# ScreenShots

Register-Pool localhost
Get-ScreenShots

$a = Invoke-Pool {Get-ScreenShot}
Show-ScreenShot $a

###################################################################################
#Browsers

Invoke-Pool {Start-Chrome "http://websocket.org/echo.html" -Kiosk}
Invoke-Pool {Enable-KioskFilter}
sleep 10
Invoke-Pool {Disable-KioskFilter }
Invoke-Pool {Stop-Chrome}

###################################################################################


