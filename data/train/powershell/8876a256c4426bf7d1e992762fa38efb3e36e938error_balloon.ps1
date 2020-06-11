[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
$balloon = New-Object System.Windows.Forms.NotifyIcon
$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balloon.Icon = $icon
$balloon.BalloonTipIcon = 'Error'
$balloon.BalloonTipText = 'Please go home for the day'
$balloon.BalloonTipTitle = 'HardDrive Crash'
$balloon.Visible = $true
$balloon.ShowBalloonTip(10000)
