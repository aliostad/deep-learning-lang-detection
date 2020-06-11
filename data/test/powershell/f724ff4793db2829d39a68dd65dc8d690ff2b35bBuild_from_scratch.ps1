

function init {
 
## load SMO assemblies
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}



init
## set an SMO as well as a server object
$Smo = "Microsoft.SqlServer.Management.Smo."
#$server = new-object ($Smo + 'server') "DISPATCHSPARE1\MSSMLBIZ"
$server = new-object ($Smo + 'server') "DISPATCHSPARE1\sx"
#$server.Databases | ? { $_.IsSystemObject -eq $false } | ft name -autosize
 $a= @( `
 @{db='dispatch_ct'; usr= 'ctuser'}, `
 @{db='dispatch_sutton'; usr= 'ross_sutton'},`
 @{db='dispatch_me'; usr= 'meuser'},`
 @{db='dispatch_production'; usr= 'ross'},`
 @{db='dispatch_vt'; usr= 'vtuser'}`
 )
 
foreach ($i in 0..4) {
   $dbname = $($a[$i].db)   
   $db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, $dbname)
   $db.Create()
   'db is: {0,10} user is:{1,7}'  -f $( $a[$i].db), $a[$i].usr    
 } 

sqlcmd -S DispatchSpare1\SX -U sa -P 123ross321 -i ./dbscripts/create_5_logins.sql 
sqlcmd -S DispatchSpare1\SX -U sa -P 123ross321 -i ./dbscripts/restore_5_databases.sql 
sqlcmd -S DispatchSpare1\SX -U sa -P 123ross321 -i ./dbscripts/create_5_users.sql 