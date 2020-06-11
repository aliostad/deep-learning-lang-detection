# sa password is:
#   RossExpress1$
#   now:  Pas$word1
#   next one;  123ross321 ...  just so Gregg can remember (rgk 4/20/2010:
#  unless I can change it...
#  I changed it and Ran this script once..   rgk 4/20/10 
#


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
$server = new-object ($Smo + 'server') "SPARE3\SQLEXPRESS"
#'server is: {0,10}'  -f $server     
 $a= @( `
 @{db='dispatch_ct'; usr= 'ctuser'}, `
 @{db='dispatch_sutton'; usr= 'ross_sutton'},`
 @{db='dispatch_me'; usr= 'meuser'},`
 @{db='dispatch_production'; usr= 'ross'},`
 @{db='dispatch_vt'; usr= 'vtuser'}`
 )
 
foreach ($i in 0..4) {
   $dbname =  $($a[$i].db)   
   $db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, $dbname)
   $db.Create()
   'db is: {0,10} user is:{1,7}'  -f $( $a[$i].db), $a[$i].usr    


 } 

## for now, use a SQL script to create the users.
## make sure the logins already exist and have appropriate default databases...
## see : dbscripts create_5_logins.sql and create_5_users.sql
## then;  restore the databases with another script...

 

