$solutionName = "GoodData"
$projectName = "GoodDataService"
$localNugetFeed = "C:\code\LocalNugetFeed\"
$workFolder = Get-Location
$packageFolder = $workFolder.ToString().Replace("buildscripts","")
$clean = "msbuild " + $solutionName + ".sln /t:Clean"
$build = "msbuild " + $solutionName + ".sln /t:Build /p:Configuration=Release"
$nupack = "nuget pack " + $projectName + "/" + $projectName + ".csproj -Symbols" 
$copyPackage = "Get-ChildItem " + $packageFolder + " -Recurse -Filter " + $projectName + "*.nupkg | Copy-Item -Destination " + $localNugetFeed

write("Commands......")
write($basedir)
write($clean)
write($build)
write($nupack)
write($copyPackage)

cd ..

Invoke-Expression $clean
Invoke-Expression $build
Invoke-Expression $nupack
Invoke-Expression $copyPackage

cd buildscripts