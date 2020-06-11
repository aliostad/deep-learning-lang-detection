[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$objBalloon = New-Object System.Windows.Forms.NotifyIcon 
$objBalloon.Icon = "C:\temp\graph32.ico"

# You can use the value Info, Warning, Error
$objBalloon.BalloonTipIcon = "Info"

# Put what you want to say here for the Start of the process
$objBalloon.BalloonTipTitle = "Begin Title" 
$objBalloon.BalloonTipText = "Begin Message" 
$objBalloon.Visible = $True 
$objBalloon.ShowBalloonTip(10000)

# Do some work
$i =1000000 
While ($i -gt 1) {$i -=1}

# Put what you want to say here for the completion of the process
$objBalloon.BalloonTipTitle = "End Title" 
$objBalloon.BalloonTipText = "End Message" 
$objBalloon.Visible = $True 
$objBalloon.ShowBalloonTip(10000)


