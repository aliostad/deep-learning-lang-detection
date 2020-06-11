#Desktop Location
$desktop = [Environment]::GetFolderPath("Desktop")

# Copy Files
Copy-Item -path c:\vagrant\files\* -Destination $desktop -Recurse

# Create Shortcuts
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktop\USMMC.lnk")
$Shortcut.TargetPath = "$desktop\USM2C\Tool.exe"
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$desktop\Pat 3.lnk")
$Shortcut.TargetPath = "$desktop\Process Analysis Toolkit\Process Analysis Toolkit 3.5.1\Pat 3.exe"
$Shortcut.Save()
