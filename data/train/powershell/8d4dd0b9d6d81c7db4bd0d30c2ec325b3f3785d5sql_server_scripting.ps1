set-psdebug -strict
$ErrorActionPreference = "Stop"

Function Get-DatabaseEngine() {
	$MicrosoftSqlServer = 'Microsoft.SqlServer'
	
	$SMO = [System.Reflection.Assembly]::LoadWithPartialName("$MicrosoftSqlServer.SMO")
	if ((($SMO.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[System.Reflection.Assembly]::LoadWithPartialName("$MicrosoftSqlServer.SMOExtended") | Out-Null
	}
	
	return "$MicrosoftSqlServer.Management.Smo"
}

Function Get-Server($DatabaseEngine) {
	$ServerName = Read-Host "   * Server name "	
	return new-object ("$DatabaseEngine.Server") $ServerName
}

Function Select-Database($Server) {
	$i = 1
	$Databases = [System.Collections.ArrayList]$Server.Databases | where { $_.Name -NotMatch 'tempdb|master|model|msdb' }

	Write-Host "`n   List of available databases :" -foreground "green"
	
	foreach ($Database in $Databases) {
	   Write-Host "`t[$i] -" $Database.Name
	   $i++
	 }
	$i--
	
	$DatabaseNumber = 0
	while ((1..$i) -notcontains $DatabaseNumber) {
		$DatabaseNumber = read-host "`n   * Choose a database number " 
	} 
	
	$DatabaseNumber = [int] $DatabaseNumber - 1 
	$DatabaseName = $Databases[$DatabaseNumber].Name
	$DatabaseName = $DatabaseName.trim("[", "]")
	
	return $Server.Databases[$DatabaseName]
}

Function SaveFile($initialDirectory) { 
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
	Out-Null

	$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	$SaveFileDialog.initialDirectory = $initialDirectory
	$SaveFileDialog.filter = "SQL Files (*.sql)| *.sql"
	$SaveFileDialog.ShowDialog() | Out-Null
	
	if (! $SaveFileDialog.filename) { 
		Write-Host " Aborting...`n" -foreground "red"
		exit 1 
	}
	
	if (Test-Path $SaveFileDialog.FileName) {
		Remove-Item $SaveFileDialog.FileName
	}
	
	return $SaveFileDialog.FileName
}

Function Get-ScripterWithOptions() {
	$Scripter = New-Object ("$DatabaseEngine.Scripter") $Server
	
	$Scripter.Options.AppendToFile = $True
	$Scripter.Options.AllowSystemObjects = $False
	$Scripter.Options.ClusteredIndexes = $True
	$Scripter.Options.DriAll = $True
	$Scripter.Options.ScriptDrops = $False
	$Scripter.Options.IncludeHeaders = $True
	$Scripter.Options.ToFileOnly = $True
	$Scripter.Options.Indexes = $True
	$Scripter.Options.Permissions = $True
	$Scripter.Options.WithDependencies = $False
	$Scripter.Options.IncludeIfNotExists = $True
	$Scripter.Options.FileName = "$FilePath"
	
	return $Scripter
}

Function Script-Tables($Database, $Scripter) {
	Write-Host "`n   Tables scripted : " -foreground "green"
	
	$Tables = $Database.Tables | Where-object { $_.Schema -eq "dbo"  -and -not $_.IsSystemObject } 
	
	foreach ($Table in $Tables) { 
		$Scripter.Script($Table)		
		Write-Host "`t+ " $Table.Name
	}
}

Function Script-StoredProcedures($Database, $Scripter) {
	Write-Host "`n   Stored Procedures scripted : " -foreground "green"
	
	$StoredProcedures = $Database.StoredProcedures | Where-object { $_.Schema -eq "dbo"  -and -not $_.IsSystemObject } 
	
	foreach ($StoredProcedure in $StoredProcedures) { 		
		$Scripter.Script($StoredProcedure)		
		Write-Host "`t+ " $StoredProcedure.Name
	}
}

Write-Host "`n SQL Server Database Scripting Tool" -foreground "green"
Write-Host " ----------------------------------`n" -foreground "green"

$DatabaseEngine = Get-DatabaseEngine

$Server = Get-Server $DatabaseEngine

$Database = Select-Database $Server

$FilePath = SaveFile

$Scripter = Get-ScripterWithOptions
Script-Tables $Database $Scripter
Script-StoredProcedures $Database $Scripter

Write-Host "`n Script $FilePath created`n" -foreground "green"