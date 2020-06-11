
function init {
 
## load SMO assemblies
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}

init

$Smo = "Microsoft.SqlServer.Management.Smo."
$server = new-object ($Smo + 'server') "DISPATCHSPARE1\MSSMLBIZ"

 $a= @( `
 @{db='dispatch_ct'; usr= 'ctuser'}, `
 @{db='dispatch_ma'; usr= 'mauser'},`
 @{db='dispatch_me'; usr= 'meuser'},`
 @{db='dispatch_nh'; usr= 'nhuser'},`
 @{db='dispatch_vt'; usr= 'vtuser'}`
 )
 
foreach ($i in  0..4) {
   $dbname = ("xx" + $a[$i].db)   
   $db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, $dbname)
   $db.Create()
   'Created: {0,10} user is:{1,7}'  -f $("xx" + $a[$i].db), $a[$i].usr    
 } 
