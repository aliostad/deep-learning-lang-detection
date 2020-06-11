# Oracleが起動しているかどうか確認する

[void][System.Reflection.Assembly]::LoadWithPartialName("Oracle.DataAccess")

$params=@($args[1], $args[2], $args[3])

$connstr = "User ID={0};Password={1};Data Source={2}" -f $params[0],$params[1],$params[2]
$conn = New-Object Oracle.DataAccess.Client.OracleConnection($connstr)
$conn.Open()

$cmd = New-Object Oracle.DataAccess.Client.OracleCommand
$cmd.Connection = $conn
$cmd.CommandText = "select * from dual"
[void]$cmd.ExecuteNonQuery()

trap {
    $Error
    exit 9
}