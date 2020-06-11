
function init {
 
## load SMO assemblies
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum")
$null=[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
}

init
## set SMO variable
$Smo = "Microsoft.SqlServer.Management.Smo."
$server = new-object ($Smo + 'server') "DISPATCHSPARE1\MSSMLBIZ"
#$server.Databases | ? { $_.IsSystemObject -eq $false } | ft name -autosize
 $a= @( `
 @{db='dispatch_ct'; usr= 'ctuser'}, `
 @{db='dispatch_ma'; usr= 'mauser'},`
 @{db='dispatch_me'; usr= 'meuser'},`
 @{db='dispatch_nh'; usr= 'nhuser'},`
 @{db='dispatch_vt'; usr= 'vtuser'}`
 )
 
foreach ($i in  0..4) {
   $dbname = ("xx" + $a[$i].db)      
   $server.KillDatabase($dbname)
   'Dropped: {0,10} user is:{1,7}'  -f $("xx" + $a[$i].db), $a[$i].usr    
 } 
 

