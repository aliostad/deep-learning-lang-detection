## load SMO assemblies

$null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")

$null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")

$null = [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

## set SMO variable

$Smo = "Microsoft.SqlServer.Management.Smo."

$server = new-object ($Smo + 'server') "DISPATCHSPARE1\MSSMLBIZ"

#$Server = new-object Microsoft.SqlServer.Management.Smo.Server("SQL2008")
$server.KillDatabase("TestDB")
$db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, "TestDB")

$db.Create()

$server.databases | Select Name | Format-Table
