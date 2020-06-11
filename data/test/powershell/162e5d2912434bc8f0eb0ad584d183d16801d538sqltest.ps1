cls
$ok=$false
do {
    try {
        #Write-Host "Versuche DB Verbindung"
        [xml]$dbconfig = Get-Content $PSScriptRoot"\dbconfig.xml"
        $connString = "Server="+$dbconfig.dbconfig.dbserver+";Uid="+$dbconfig.dbconfig.dbuser+";Pwd="+$dbconfig.dbconfig.dbpassword+";database="+$dbconfig.dbconfig.dbname;
        # load MySQL driver and query database
        [void][system.reflection.Assembly]::LoadFrom($PSScriptRoot+"\mysql.data.dll");
        $conn = New-Object MySql.Data.MySqlClient.MySqlConnection;
        $conn.ConnectionString = $connString;
        $conn.Open();
        $ok=$true;
    }
    catch {
        . $PSScriptRoot\Config.ps1
        $ok=$false
    }
}
while ($ok -eq $false)

