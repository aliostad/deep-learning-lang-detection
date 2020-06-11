#Load all .NET binaries in the folder
Get-ChildItem -recurse "D:\Documents\Visual Studio 2010\Projects\AesSample\AesSample\bin\Debug\"|Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName)} Catch{ "***ERROR*** Not .NET assembly: " + $AssemblyName}}
#Only retrieve static private method
$BindingFlags= [Reflection.BindingFlags] "NonPublic,Static"
 
#Load method based on name
$PrivateMethod = [AesSample.AesLibStatic].GetMethod("DecryptStringSecret",$bindingFlags)
 
#Invoke
$PrivateMethod.Invoke($null,"8E3C5A3088CEA26B634CFDA09D13A7DB")