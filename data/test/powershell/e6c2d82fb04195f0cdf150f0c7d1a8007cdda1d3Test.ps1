###################################################################################
# Launcher Test-Code
# Stefan Wehrli <wehrlist@ethz.ch>
# September 2011
###################################################################################

# Start
Start-Launcher

# Select computers
Select-Pool

# Connect
Register-Pool localhost

# Hide/Show/Enable/Disable
Invoke-Pool {Show-Launcher}
Invoke-Pool {Hide-Launcher}
Invoke-Pool {Disable-Launcher}
Invoke-Pool {Enable-Launcher}

# Browser
Invoke-Pool {Show-Browser "www.google.ch" }
sleep 5
Invoke-Pool {Hide-Browser }

Invoke-Pool {Send-Browser "www.ethz.ch" 5}

#WaitForm
Invoke-Pool {Show-WaitFrom }
sleep 5
Invoke-Pool {Hide-WaitForm }

Invoke-Pool {Send-WaitForm "Can you see this?" }
Invoke-Pool {Send-WaitForm "" 5 }

#AuthForm
Invoke-Pool {Show-AuthForm}
sleep 5
Invoke-Pool {Hide-AuthForm}

###################################################################################
#Devices

#Beeping
Invoke-Pool {$launcher.beeping()}

Invoke-Pool { 
  function BeepMe { 
    for($i = 1; $i -le 8; $i++) {
      $launcher.Beeping($i*250, 200)
    }
  }
}

Invoke-Pool BeepMe

# Mouse Movement
# Does not work, need to pipe $j into remote host
for([int]$i=1; $i -lt 20; $i++) {
  $j = $i * 50
  invoke-Pool { $launcher.MouseXY($j, $j) }
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

#Volume
#Invoke-Pool { Set-Volume 100 }

###################################################################################
# Messages
Invoke-Pool {Send-Notification "You won a million dollars!"}

###################################################################################
# ScreenShots

Get-Screen localhost

$a = Invoke-Pool {Get-ScreenShot}
Show-ScreenShot $a

###################################################################################
#Apps

Invoke-Pool {start-chrome "http://websocket.org/echo.html" }
Invoke-Pool {Enable-KioskFilter}
sleep 10
Invoke-Pool {Disable-KioskFilter }
Invoke-Pool {Stop-Chrome}

###################################################################################


