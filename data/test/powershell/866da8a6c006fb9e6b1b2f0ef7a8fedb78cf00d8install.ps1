param($rootPath, $toolsPath, $package, $project)

$configFileFrom = $toolsPath + "\..\src\dotnet.watchr.rb"
$configFileTo = "dotnet.watchr.rb"

$watchrFileFrom = $toolsPath + "\..\src\watcher_dot_net.rb"
$watchrFileTo = "watcher_dot_net.rb"

$redFileFrom = $toolsPath + "\..\src\red.png"
$redFileTo = "red.png"

$greenFileFrom = $toolsPath + "\..\src\green.png"
$greenFileTo = "green.png"

$sidekickbatFileFrom = $toolsPath + "\..\src\sidekick.bat"
$sidekickbatFileTo = "sidekick.bat"

$watchrbatFileFrom = $toolsPath + "\..\src\watchr.bat"
$watchrbatFileTo = "watchr.bat"

$sidekickcsFileFrom = $toolsPath + "\..\src\sidekickapp.cs"
$sidekickcdFileTo = "sidekickapp.cs"

if(!(Test-Path $configFileTo))
{
  Copy-Item $configFileFrom $configFileTo
  Copy-Item $watchrFileFrom $watchrFileTo
  Copy-Item $redFileFrom $redFileTo
  Copy-Item $greenFileFrom $greenFileTo
  Copy-Item $sidekickcsFileFrom $sidekickcsFileTo
  Copy-Item $sidekickbatFileFrom $sidekickbatFileTo
  Copy-Item $watchrbatFileFrom $watchrbatFileTo
}
else
{
  Write-Host ""
  Write-Host "files were not copied to root directory, because it looks like they already exist, go to the package directory and copy all the files from " $toolsPath "\..\src to the root directory (unless you've changed them of course)"
}

