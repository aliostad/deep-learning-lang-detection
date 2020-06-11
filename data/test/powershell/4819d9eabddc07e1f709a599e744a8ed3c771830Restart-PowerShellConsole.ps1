function Restart-PowerShellConsole {
	param(
		$Message = "PowerShell Console has been restarted",
		[switch]$Su
	)
	
	$Env:PowerShellConsoleStartUpMessage = $Message
	$Env:PowerShellConsoleStartUpPath = $PWD.Path
	Start-Process -FilePath "##ConEmuCExecutablePath##" -NoNewWindow -ArgumentList "/SILENT /EXPORT=GUI PowerShellConsoleStartUpMessage PowerShellConsoleStartUpPath" -Wait

    Start-Process -FilePath "##ConEmuExecutablePath##" -ArgumentList "/cmd $(if ($Su) { "{PowerShell (Administrator)}" } else { "{PowerShell}" })"
	Start-Process -FilePath "##ConEmuCExecutablePath##" -ArgumentList "-GuiMacro Close(7)" -Wait -NoNewWindow
}