function SQL.DatabaseExists {
    [CmdLetBinding()]
    param(
        [string] $DatabaseServer = [net.dns]::gethostname(),
        [String] $DatabaseInstance = '',
        [string] $DatabaseName = $(throw 'Please specify a database name.')
                
      )

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null

    if (!([string]::IsNullOrEmpty($DatabaseInstance))){
        $DatabaseServer = "$($DatabaseServer)\$($DatabaseInstance)"
    }
   
    $smoserver = New-Object ( "Microsoft.SqlServer.Management.Smo.Server" ) $DatabaseServer
    
    if ($smoserver.Databases[$Databasename]) {
        write-verbose "Database $($Databasename) on the SQL Server $($DatabaseServer) exists!"
        return $TRUE
    }else
    {
        Write-verbose "Database $($Databasename) on the SQL Server $($DatabaseServer) not exists!"
        return $FALSE
    }
    
}