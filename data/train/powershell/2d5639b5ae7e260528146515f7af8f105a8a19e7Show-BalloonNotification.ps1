Function Show-BalloonNotification {
param (
	[Parameter(Mandatory=$true)][string]$Message,
	[string]$Title,
	[ValidateSet("None", "Info", "Warning", "Error")][string]$Icon,
	[int]$Duration=10000
)
Begin {
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$Notify = New-Object System.Windows.Forms.NotifyIcon
$Notify.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
}

Process {
$Notify.Visible = $True 
$Notify.ShowBalloonTip($Duration, $Title, $Message, $Icon)
}

End {
start-sleep -m 10000
$Notify.Visible = $False
}

}
