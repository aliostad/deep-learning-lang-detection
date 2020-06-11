<#
.SYNOPSIS 
 This script was developed to provide a way to schedule a job (in this example every 5min) to get the server load values as calculated by the XenApp platform.
 These logs were used to understand and better provide information on the frequency and usage on multiple systems in 6.x and 7.x farms.
  
#>

Import-Module (Join-Path $env:POWERSHELL_HOME "Citrix\Citrix_Functions.ps1")
Import-Module (Join-Path $env:POWERSHELL_HOME "Libraries\General_Variables.psm1")

# SQL variables

$SQLServer = $citrix_environment.Logging.SQLServer
$Database = $citrix_environment.Logging.Database
$TableName = $citrix_environment.Logging.SessionProcesses

$ConnectionString = "Server=$SQLServer;Database=$Database;Integrated Security=True"

# Create table and add columns

$DataTable = New-Object System.Data.DataTable
$DataTable.Columns.Add("Date") | Out-Null
$DataTable.Columns.Add("CitrixServer") | Out-Null
$DataTable.Columns.Add("ServerLoad") | Out-Null
$DataTable.Columns.Add("ServerLoadPercent") | Out-Null

# Add data to the columns

Get-XAServerLoad -CitrixEnvironment 6.0 | % { 
    $Row = $DataTable.NewRow(); 
    $Row["Date"]=$_.Date;
    $Row["CitrixServer"]=$_.XAServer;
    $Row["ServerLoad"]=$_.ServerLoad;
    $Row["ServerLoadPercent"]=$_.ServerLoadPercent;
    $DataTable.Rows.Add($Row)
}

Get-XAServerLoad -CitrixEnvironment 7.6 | % { 
    $Row = $DataTable.NewRow(); 
    $Row["Date"]=$_.Date;
    $Row["CitrixServer"]=$_.XAServer;
    $Row["ServerLoad"]=$_.ServerLoad;
    $Row["ServerLoadPercent"]=$_.ServerLoadPercent;
    $DataTable.Rows.Add($Row)
}

# Write rows to SQL table

$bulkCopy = [Data.SqlClient.SqlBulkCopy] $ConnectionString
$bulkCopy.DestinationTableName = $TableName
$bulkCopy.WriteToServer($DataTable)

# Clean-up tasks

$bulkCopy.Close()