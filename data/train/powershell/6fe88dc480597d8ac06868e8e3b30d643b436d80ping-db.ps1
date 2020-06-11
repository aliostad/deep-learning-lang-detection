param(
   [string] $serverName = $(throw 'serverName is required'),
   [string] $database = 'master'
)


$connectionString = "Server=$serverName;Database=$database;Integrated Security=SSPI"

write-host "Attempting to contact via connection string $connectionString"

# Formulate the query we'll run
$query = 'select 2+2'

# Load the System.Data assembly for access to SQL Server
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Data")

$serverConn = new-object 'system.data.sqlclient.SqlConnection' $connectionString

trap { 
    write-host -foreground red "Failed to contact $serverName"
    write-host ('[{0}] {1}' -f 
        $_.exception.getbaseexception().gettype().name, 
        $_.exception.getbaseexception().message)
    continue 
}
&{
    $serverConn.Open()

    $sqlCommand = new-object 'system.data.sqlclient.SqlCommand' $query, $serverConn

    $result = $sqlCommand.ExecuteScalar()

    if ($result -eq 4) { write-host -foreground green "Successful ping of server $serverName" }
    else { throw "unexpected result from query: $result" }
}
