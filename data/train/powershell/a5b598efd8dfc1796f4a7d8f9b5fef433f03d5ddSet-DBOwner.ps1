#Get-SQLServer
#Manning PowerShell In Depth Chapter 15
# import SQL Server module. Test to see if the SQLPS module is loaded, and if not, load it
<#if (-not(Get-Module -name 'SQLPS')) {
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) {
    Push-Location # The SQLPS module load changes location to the Provider, so save the current location
	Import-Module -Name 'SQLPS' -DisableNameChecking
	Pop-Location # Now go back to the original location
    }
  }#>

Import-Module -Name 'SQLPS' -DisableNameChecking
$instance = "JLANGDON\MSSQLSERVER2012"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance

$dbName = "TestDB"
$db = $server.Databases[$dbName]
#display current owner
$db.Owner
#change owner
#SetOwner requires two parameters (string, boolean):
#loginName and overrideIfAlreadyUser
try {
 $db.SetOwner('Mathematica\JELangdon', $TRUE)  #check that login exists
} catch [Exception] {
 write-host $_.Exception.GetType().FullName; 
  write-host $_.Exception.Message; 
}
#refresh db
$db.Refresh()
#check Owner value
$db.Owner