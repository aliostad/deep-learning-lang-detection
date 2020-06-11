#Load SMO assemblies
$CentralManagementServer = "andrewctest.testnet.red-gate.com\sql2008"
$MS='Microsoft.SQLServer'
@('.SMO', '.Management.RegisteredServers', '.ConnectionInfo') |
     foreach-object {if ([System.Reflection.Assembly]::LoadWithPartialName("$MS$_") -eq $null) {"missing SMO component $MS$_"}}

$connectionString = "Data Source=$CentralManagementServer;Initial Catalog=master;Integrated Security=SSPI;"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection($connectionString)
$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection($sqlConnection)
$CentralManagementServerStore = new-object Microsoft.SqlServer.Management.RegisteredServers.RegisteredServersStore($conn)

$My="$ms.Management.Smo" #
$CentralManagementServerStore.ServerGroups["DatabaseEngineServerGroup"].GetDescendantRegisteredServers() |
      Select-object ServerName |get-unique -ontype
"did that work"


