
# List all SQL Servers in a network

[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | out-null
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.Sdk.Sfc") | out-null
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlEnum") | out-null
$SmoObject =[Microsoft.SqlServer.Management.Smo.SmoApplication]
$ServerList = $SmoObject::EnumAvailableSqlServers($false)
foreach ($ServerRow in $ServerList.Rows) {
	Write-Host $ServerRow[0] $ServerRow[4]
}


