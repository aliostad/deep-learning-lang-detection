#Welcome Message etc
"Welcome to Scheduled Task Exporter"
"This script is used to export all Scheduled Tasks on Windows server"

#Variables and main functions section
$RemoteMachine = $($Selection = Read-Host "Server to export from, FQDN required! Localhost is Default"
If ($Selection) {$Selection} Else {'Localhost'})
$SaveDirectory = Read-Host "Directory to save exported tasks"
$Check = Test-Path -PathType Container $SaveDirectory
	If($Check -eq $False)
	{
		"Directory: $SaveDirectory not found! Creating Directory!"
		New-Item $SaveDirectory -type Directory -Force | Out-Null
	}
	
#Main Code
$ScheduledService = New-Object -ComObject("Schedule.Service")
$ScheduledService.Connect("$RemoteMachine")
$ExportTasks = $ScheduledService.GetFolder("\").GetTasks(0)
$OutputFileTemp = "$SaveDirectory\{0}.xml"
 
$ExportTasks | ForEach-Object {
	$Xml = $_.Xml
	$TaskName = $_.Name
	$FinalFile = $OutputFileTemp -f $TaskName
	$Xml | Out-File $FinalFile
}

"All Scheduled Tasks have been exported to the following directory -> $SaveDirectory"
"From $RemoteMachine"