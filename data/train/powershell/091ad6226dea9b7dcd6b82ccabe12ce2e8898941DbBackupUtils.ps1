function Backup-Db(
    [parameter(Mandatory = $true)][string]$DbHost,
    [parameter(Mandatory = $true)][string]$DbName,
    [parameter(Mandatory = $true)][string]$UserName,
    [parameter(Mandatory = $true)][string]$Password) {

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Backup") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")

    # Determine Execution Policy
    $executionPolicy = Get-ExecutionPolicy
    if($executionPolicy -eq 'Restricted')
    {
        Set-ExecutionPolicy RemoteSigned
    }

    # Connect to database 
    $server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $DbHost
    $server.ConnectionContext.LoginSecure = $false
    $server.ConnectionContext.Login = $UserName
    $server.ConnectionContext.Password = $Password

    $db = $server.Databases[$DbName]

    try {

    $timestamp = Get-Date -format yyyy-MM-dd-HHmmss
    $backupDirectory = $server.Settings.BackupDirectory
    $dbName = $db.Name

    Write-Host "Backing up $DbName to $backupDirectory"

    $smoBackup = New-Object ("Microsoft.SqlServer.Management.Smo.Backup")
    $smoBackup.Action = "Database"
    $smoBackup.BackupSetDescription = "Full Backup of " + $dbName
    $smoBackup.BackupSetName = $dbName + " Backup"
    $smoBackup.Database = $dbName
    $smoBackup.MediaDescription = "Disk"
    $backupFile = $dbName + "_" + $timestamp + ".bak"
    $smoBackup.Devices.AddDevice($backupDirectory + "\" + $backupFile, "File")
    $smoBackup.SqlBackup($server)

    Write-Host "`n`tFile: $backupFile`n"

    Write-Host -Fore White -Back DarkGreen "Backup of $DbName complete"

    }
    catch {
        # Write out inner exceptions
        $ex = $_.Exception
        While($ex.InnerException) {
            $ex = $ex.InnerException
            Write-Host $ex.Message
        }

        throw 'An Error occured: {0}' -f $_.Exception.Message; `
        
        Write-Host "Backup failed."
        
        # Return exit code to indicate that the database build failed, normally returns 0
        exit 1099
    }
}

function Restore-Db(
    [parameter(Mandatory = $true)][string]$DbHost,
    [parameter(Mandatory = $true)][string]$DbName,
    [parameter(Mandatory = $true)][string]$Restore,
    [parameter(Mandatory = $true)][string]$UserName,
    [parameter(Mandatory = $true)][string]$Password) {

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Backup") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")

    # Determine Execution Policy
    $executionPolicy = Get-ExecutionPolicy
    if($executionPolicy -eq 'Restricted')
    {
        Set-ExecutionPolicy RemoteSigned
    }

    # Connect to database 
    $server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $DbHost
    $server.ConnectionContext.LoginSecure = $false
    $server.ConnectionContext.Login = $UserName
    $server.ConnectionContext.Password = $Password

    $db = $server.Databases[$DbName]
    $timestamp = Get-Date -format yyyyMMddHHmmss
    $backupDirectory = $server.Settings.BackupDirectory
    $dbName = $db.Name


    try {

    $backupFile = $backupDirectory + "\" + $Restore
    Write-Host "`n`tRestoring $dbName from $backupFile"

    $backupDevice = New-Object ("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($backupFile, "File")
    $smoRestore = new-object("Microsoft.SqlServer.Management.Smo.Restore")
     
    # Settings for restore
    $smoRestore.NoRecovery = $false;
    $smoRestore.ReplaceDatabase = $true;
    $smoRestore.Action = "Database"
     
    # Show every 10% progress
    $smoRestore.PercentCompleteNotification = 10;
    $smoRestore.Devices.Add($backupDevice)
    $smoRestoreDetails = $smoRestore.ReadBackupHeader($server)

    $smoRestore.Database = $smoRestoreDetails.Rows[0]["DatabaseName"]
    $server.KillDatabase($DbName)

    $smoRestore.SqlRestore($server)

    Write-Host -Fore White -Back DarkGreen "Restore of $DbName complete"

    }
    catch {
        # Write out inner exceptions
        $ex = $_.Exception
        While($ex.InnerException) {
            $ex = $ex.InnerException
            Write-Host $ex.Message
        }

        throw 'An Error occured: {0}' -f $_.Exception.Message; `
        
        Write-Host "Restore failed."
        
        # Return exit code to indicate that the database build failed, normally returns 0
        exit 1099
    }
}