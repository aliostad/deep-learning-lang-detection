param($rootPath, $toolsPath, $package, $project)

$rakeDotNetFrom = $toolsPath + "\..\src\RakeDotNet"
$rakeDotNetTo = "RakeDotNet"

$rakeFileFrom = $toolsPath + "\..\src\Rakefile.rb"
$rakeFileTo = "Rakefile.rb"

$devYmlFrom = $toolsPath + "\..\src\dev.yml"
$devYmlTo = "dev.yml"

$nginxFrom = $toolsPath + "\..\src\nginx"
$nginxTo = "nginx"

if(!(Test-Path $rakeFileTo))
{
  Copy-Item $rakeDotNetFrom $rakeDotNetTo -recurse
  Copy-Item $nginxFrom $nginxTo -recurse
  Copy-Item $rakeFileFrom $rakeFileTo
  Copy-Item $devYmlFrom $devYmlTo
}
