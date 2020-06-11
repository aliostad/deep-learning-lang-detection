[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
 
# variables requring adjustment
$server = "(local)\SQL2008"
$backup_path = "C:\backup\sql\"   # <- MAKE SURE THE SQL SERVER ENGINE has permission to write to this directory!
$databases_to_backup = "database1", "database2"

# connection to server & timestamp1
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server $server
$timestamp = Get-Date -format yyyyMMdd_HHmm

foreach ($database in $databases_to_backup)
{
    # setup our backup parameters
    $dbBackup = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
    $dbBackup.Action = "Database"    
    $dbBackup.Database = $database
    $dbBackup.Devices.AddDevice($backup_path + $dbBackup.Database + $timestamp + ".bak", "File")
    $dbBackup.Action="Database"
    $dbBackup.Incremental = 0
    $dbBackup.CopyOnly = $TRUE
    $dbBackup.Initialize = $TRUE
    $dbBackup.CompressionOption = 0

    # execute the backup
    $dbBackup.SqlBackup($srv)
}

# Remove all .BAK files in backup files older than 360 minutes (6 hours)
Get-ChildItem -path $backup_path -include *.bak -recurse | where {$_.Lastwritetime -lt (date).addminutes(-360)} | remove-item