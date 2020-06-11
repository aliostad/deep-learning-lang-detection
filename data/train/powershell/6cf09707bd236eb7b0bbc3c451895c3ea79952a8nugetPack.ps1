$root = (split-path -parent $MyInvocation.MyCommand.Definition) + '\..'
Write-Host "root dir is $root"

$version = [System.Reflection.Assembly]::LoadFile("$root\KStringExtension\bin\Release\KStringExtension.dll").GetName().Version
$versionStr = "{0}.{1}.{2}" -f ($version.Major, $version.Minor, $version.Build)

Write-Host "Setting .nuspec version tag to $versionStr"

$content = (Get-Content $root\nuget\KString.nuspec) 
$content = $content -replace '\$version\$',$versionStr

$content | Out-File $root\nuget\KString.compiled.nuspec

& $root\nuget\nuget.exe pack $root\nuget\KString.compiled.nuspec
