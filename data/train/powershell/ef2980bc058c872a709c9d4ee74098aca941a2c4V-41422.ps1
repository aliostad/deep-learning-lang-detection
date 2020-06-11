<#
Applies finding V-41422 from the SQL Server 2012 Database STIG
Summary: Configure maximum number of concurrent session
#>

function Set-MaxConnections ($serverName, $maxConnections) {

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection "server=$serverName;database=master;Integrated Security=SSPI"
    $sqlConnection.Open()

    $sqlCommand = $sqlConnection.CreateCommand()

    $query = @"
        USE master

        EXEC sys.sp_configure N'show advanced options', N'1' RECONFIGURE WITH OVERRIDE
        EXEC sys.sp_configure N'user connections', $maxConnections
        EXEC sys.sp_configure N'show advanced options', N'0' RECONFIGURE WITH OVERRIDE
"@

    $sqlCommand.CommandText = $query

    $sqlCommand.ExecuteNonQuery()

    $sqlConnection.Close()

}