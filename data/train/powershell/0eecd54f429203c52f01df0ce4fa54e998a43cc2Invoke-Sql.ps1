Function Invoke-Sql {
    Param(
        [Parameter(Mandatory = $true)]
        [String]
        $ProviderName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConnectionString,

        [Parameter(Mandatory = $true)]
        [String]
        $Sql
    )

    $ProviderFactory = [System.Data.Common.DbProviderFactories]::GetFactory($ProviderName)
    $Conn = $ProviderFactory.CreateConnection()
    $Conn.ConnectionString = $ConnectionString
    $Conn.Open()

    $Cmd = $Conn.CreateCommand()
    $Cmd.CommandText = $Sql

    $Reader = $Cmd.ExecuteReader()
    if ($Reader) {
        $Table = New-Object System.Data.DataTable
        $Table.Load($Reader)
    }

    $Cmd.Dispose()
    $Conn.Dispose()
}
