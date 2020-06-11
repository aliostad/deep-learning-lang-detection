# (C) 2015 Patrick Lambert - http://dendory.net
#
# This script connects to a SQL Server database, lists all tables, and saves the data to a series of CSV files
#
param([Parameter(Mandatory=$true)][string]$dbserver, [Parameter(Mandatory=$true)][string]$dbname, [Parameter(Mandatory=$true)][string]$userid, [Parameter(Mandatory=$true)][string]$passwd)

$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=$dbserver; Database=$dbname; User Id=$userid; Password=$passwd"
$con.Open()
$sql = $con.CreateCommand()
$sql.CommandText = "SELECT * FROM [$dbname].[INFORMATION_SCHEMA].[TABLES]"
$result = $sql.ExecuteReader()
$tables = New-Object System.Data.DataTable
$tables.Load($result)
[int32]$i = 0;
foreach($table in $tables)
{
    Write-Progress -Activity "Fetching tables" -Status $table.TABLE_NAME -PercentComplete ($i/$($tables.Rows.Count)*100)
    $i++
    $sql.CommandText = "SELECT * FROM [$dbname].[$($table.TABLE_SCHEMA)].[$($table.TABLE_NAME)]"
    $result = $sql.ExecuteReader()
    $data = New-Object System.Data.DataTable
    $data.Load($result)
    $data | ConvertTo-Csv -NoTypeInformation | Out-File "$dbname.$($table.TABLE_SCHEMA).$($table.TABLE_NAME).csv"
}
$con.Close()
