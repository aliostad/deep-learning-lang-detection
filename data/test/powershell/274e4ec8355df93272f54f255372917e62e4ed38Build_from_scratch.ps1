

function init {
 
## load SMO assemblies
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}

init
$h = hostname
if ($h -eq "DispatchSpare1") { 
   $hroot = "DISPATCHSPARE1\" 
   } else { 
   $hroot = "DISPATCHSPARE2\"
} 
if ($h -eq 'Spare3') {
  $hroot = 'SPARE3\'
}
$SS=  $hroot + "SQLEXPRESS"
## set an SMO as well as a server object
$Smo = "Microsoft.SqlServer.Management.Smo."
#$server = new-object ($Smo + 'server') "DISPATCHSPARE1\MSSMLBIZ"
$server = new-object ($Smo + 'server') $S
#$server.Databases | ? { $_.IsSystemObject -eq $false } | ft name -autosize
 $a= @( `
 @{db='dispatch_ct'; usr= 'ctuser'}, `
 @{db='dispatch_sutton'; usr= 'mauser'},`
 @{db='dispatch_me'; usr= 'meuser'},`
 @{db='dispatch_production'; usr= 'nhuser'},`
 @{db='dispatch_vt'; usr= 'vtuser'}`
 )
 
foreach ($i in 0..4) {
   $dbname = $($a[$i].db)   
   $db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, $dbname)
   `$db.Create()
   'db is: {0,10} user is:{1,7}'  -f $( $a[$i].db), $a[$i].usr    
 } 
write $S
sqlcmd -S $S -U sa -P 123ross321 -i ./dbscripts/create_5_logins.sql 
sqlcmd -S $S -U sa -P 123ross321 -i ./dbscripts/restore_5_databases.sql 
./R #sqlcmd -S $S -U sa -P 123ross321 -i ./dbscripts/create_5_users.sql 
foreach ($i in 0..4) {
   $dbname = $($a[$i].db)   
   #sqlcmd -S $SS -U sa -P 123ross321 -Q "use master; drop database $dbname;"
}
