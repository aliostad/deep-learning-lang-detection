Function GetRowcount ($server, $database)
{

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | Out-Null

$srv =  New-Object ('Microsoft.SqlServer.Management.SMO.Server') $server
$db = $srv.Databases[$database]

    foreach ($table in $db.Tables)
    {
        $table.Name + ": " + $table.RowCount
    }

}

## Call it:
GetRowcount -server "SERVER\INSTANCE" -database "Database"



Function DropBAKTables ($server, $database)
{

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | Out-Null

$srv =  New-Object ('Microsoft.SqlServer.Management.SMO.Server') $server
$db = $srv.Databases[$database]

    foreach ($table in $db.Tables)
    {
        $x = $table.Name
        if ($x -like "*BAK*")
        {
            $table.Drop
        }
    }

}

DropBAKTables -server "SERVER\INSTANCE" -database "Database"
