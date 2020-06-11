# http://www.zerrouki.com/balloontooltip/
Function BalloonTooltip {
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$balloon = New-Object System.Windows.Forms.NotifyIcon
	$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
	$icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
	$balloon.Icon = $icon
	$balloon.BalloonTipIcon = 'Info'
	$balloon.BalloonTipText = 'Completed Operation'
	$balloon.BalloonTipTitle = 'Done'
	$balloon.Visible = $true
	$balloon.ShowBalloonTip(10000)
}