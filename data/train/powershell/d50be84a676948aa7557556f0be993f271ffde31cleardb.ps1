cls

$path = Split-Path $Myinvocation.mycommand.path
Remove-Module "$($path)\posharchfunctions.ps1" -ea 0 | Out-Null
import-Module "$($path)\posharchfunctions.ps1" -ea 0 | Out-Null

$pwd = "Test"
$dst = "w:\temp\enc"
$dbp = "$($path)\test.db"

#Load SQLite
get-childitem -Path $path -Filter "*.dll" | % { [System.Reflection.Assembly]::LoadFile($_.FullName) | Out-Null } 

#Open/Create SQLite DB	
if( !(Test-Path $dbp) ) {
	connectDb $dbp
	
	execSql ([System.IO.File]::ReadAllText("$($path)\posharch.db.sql"))
} else {
	connectDb $dbp
}

Get-ChildItem $dst -Recurse | Remove-Item -Confirm:$false -Force -Recurse
execSql "delete from versions"
execSql "delete from files"

$sqlitedb.close()

