function Save-CommandHistory {
<#
.Synopsis
    Save the current session's command history allowing it to be used in a future session.
.Description
    Set up a PowerShell.Exiting exent handler to save the current session's command history.
	This command history will be saved in a file named `.ps_history` located in the user's
	profile folder.
#>
	$global:MaximumHistoryCount = 4096

	$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
	Register-EngineEvent PowerShell.Exiting -Action {
		Get-History | Export-Clixml $HistoryFilePath
	} | Out-Null
	if (Test-Path $HistoryFilePath) {
		Import-Clixml $HistoryFilePath | Add-History
	}
}
