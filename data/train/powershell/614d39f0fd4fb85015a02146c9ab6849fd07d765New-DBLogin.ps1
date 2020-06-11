param([Parameter(Mandatory=$true)]$DBName,`
	  [Parameter(Mandatory=$true)]$LoginName)
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | out-null
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server')
$login = new-object ('Microsoft.SqlServer.Management.Smo.Login') ($s, $LoginName)
$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
$login.DefaultDatabase = $DBName
$login.Create()