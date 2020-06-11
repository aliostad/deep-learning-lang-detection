#load assemblies
[System.Reflection.Assembly]::Load("Microsoft.SqlServer.Smo,Culture=Neutral,Version=9.0.242.0,PublicKeyToken=89845dcd8080cc91") | out-null
[System.Reflection.Assembly]::Load("Microsoft.SqlServer.ConnectionInfo,Culture=Neutral,Version=9.0.242.0,PublicKeyToken=89845dcd8080cc91") | out-null
[System.Reflection.Assembly]::Load("System.Data,Culture=Neutral,Version=2.0.0.0,PublicKeyToken=b77a5c561934e089") | out-null
[System.Reflection.Assembly]::Load("Microsoft.SqlServer.SqlEnum,Culture=Neutral,Version=9.0.242.0,PublicKeyToken=89845dcd8080cc91") | out-null


[string] $tsqlBkp = C:\TFSWorkspaces\VS2008\SRM\Branches\DEVELOPMENT\PowerShell\PowerShellScripts\TFSDeployerScripts\New-SQLBackup.ps1 $('\\us73media1\SRM\<INSTANCE>_<DATABASE>_<TYPE>_<DATETIME yyyymmdd_ hhnnss>.sqb') $("SRMTest") $("Backup before sync job for build:")
[string] $connStr = "data source=DS73SQLDEV03;Initial Catalog=SRMTest;User ID=TFSDeployer;pwd=simple;"

$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)
$sconn = new-object Microsoft.SqlServer.Management.Common.ServerConnection($conn)
$server = new-object Microsoft.SqlServer.Management.Smo.Server($sconn)

$returnCodes = $server.ConnectionContext.ExecuteWithResults($tsqlBkp)

$returnCodes