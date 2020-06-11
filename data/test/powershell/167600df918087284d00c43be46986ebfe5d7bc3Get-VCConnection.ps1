# Load Assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
# Create new Objects
$objForm = New-Object System.Windows.Forms.Form
$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
$objContextMenu = New-Object System.Windows.Forms.ContextMenu
$ExitMenuItem = New-Object System.Windows.Forms.MenuItem
$credsMenuItem = New-Object System.Windows.Forms.MenuItem
$vcMenuItems = New-Object System.Windows.Forms.MenuItem
# get credential
$credential = (Get-Credential -Credential $null)
$objContextMenu.MenuItems.Clear()
$vcMenuItem = New-Object System.Windows.Forms.MenuItem
$vcMenuItem.Text = "vCenter friendly name"
$vcMenuItem.add_Click({Start-Process -FilePath "C:\Program Files (x86)\VMware\Infrastructure\Virtual Infrastructure Client\Launcher\VpxClient.exe" -ArgumentList @("-i", "-s", "vcenter1", "-u", $credential.UserName, "-p", $credential.GetNetworkCredential().password)})
$objContextMenu.MenuItems.Add($vcMenuItem) | Out-Null
# Create an Exit Menu Item
#$ExitMenuItem.Index = $i+1
$ExitMenuItem.Text = "E&xit"
$ExitMenuItem.add_Click({
		$objForm.Close()
		$objNotifyIcon.visible = $false
	})
	
# Add the Exit and Add Content Menu Items to the Context Menu
$objContextMenu.MenuItems.Add("-") | Out-Null
$objContextMenu.MenuItems.Add($ExitMenuItem) | Out-Null

# Assign an Icon to the Notify Icon object
$objNotifyIcon.Icon = "P:\favicon.ico"
$objNotifyIcon.Text = "Lazy vCenter Connector"
# Assign the Context Menu
$objNotifyIcon.ContextMenu = $objContextMenu
$objForm.ContextMenu = $objContextMenu

# Control Visibilaty and state of things
$objNotifyIcon.Visible = $true
$objForm.Visible = $false
$objForm.WindowState = "minimized"
$objForm.ShowInTaskbar = $false
$objForm.add_Closing({ $objForm.ShowInTaskBar = $False })
# Show the Form - Keep it open
# This Line must be Last
$objForm.ShowDialog()
