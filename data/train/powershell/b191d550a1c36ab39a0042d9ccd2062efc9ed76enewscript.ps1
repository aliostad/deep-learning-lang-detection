# load assemblies
[Reflection.Assembly]::Load("Microsoft.SqlServer.Smo, `
      Version=9.0.242.0, Culture=neutral, `
      PublicKeyToken=89845dcd8080cc91")
[Reflection.Assembly]::Load("Microsoft.SqlServer.SqlEnum, `
      Version=9.0.242.0, Culture=neutral, `
      PublicKeyToken=89845dcd8080cc91")
[Reflection.Assembly]::Load("Microsoft.SqlServer.SmoEnum, `
      Version=9.0.242.0, Culture=neutral, `
      PublicKeyToken=89845dcd8080cc91")
[Reflection.Assembly]::Load("Microsoft.SqlServer.ConnectionInfo, `
      Version=9.0.242.0, Culture=neutral, `PublicKeyToken=89845dcd8080cc91")

# connect to SQL Server named instance
# server name is JUBILEE
# instance name is SQL01
# use server\instancename
$serverName = "JUBILEE\SQL01"
$server = New-Object -typeName Microsoft.SqlServer.Management.Smo.Server -argumentList "$serverName" 

# login using SQL authentication, which means we supply the username# and password$server.ConnectionContext.LoginSecure=$false;$credential = Get-Credential$userName = $credential.UserName -replace("\\","")$server.ConnectionContext.set_Login($userName)$server.ConnectionContext.set_SecurePassword($credential.Password) # clear the screencls # list connection stringWrite-Host "--------------------------------------------------------"Write-Host "Connection String : "Write-Host $server.ConnectionContext.ConnectionStringWrite-Host "--------------------------------------------------------"
