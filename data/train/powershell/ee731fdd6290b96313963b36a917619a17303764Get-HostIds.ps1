[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$SqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server -ArgumentList 'sql-resource01'
$Database = $SqlServer.Databases['VC001-DB']
$Tables = $Database.Tables
ForEach($Table in $Tables) {
	If($Table.Columns.Contains('HOST_ID')) {
		$Query = "SELECT [Table] = '" + $Table.name + "',HOST_ID FROM " + $('{0}' -f $Table) + " WHERE HOST_ID = 20641"
		Invoke-SqlCmd -Query $Query -ServerInstance 'sql-resource01' -Database 'VC001-DB'
	}
}