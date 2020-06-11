#Load all .NET binaries in the folder
Get-ChildItem -recurse "D:\Documents\Visual Studio 2010\Projects\AesSample\AesSample\bin\Debug\"|Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName)} Catch{ "***ERROR*** Not .NET assembly: " + $AssemblyName}}#Call default constructor (no argument)

$AesSample= New-Object "AesSample.AesLib"
#Call constructor with arguments using this syntax: $AesSample= New-Object "AesSample.AesLib" ("a","b")
 
#Invoke public method 
$AesSample.DecryptString("8E3C5A3088CEA26B634CFDA09D13A7DB")