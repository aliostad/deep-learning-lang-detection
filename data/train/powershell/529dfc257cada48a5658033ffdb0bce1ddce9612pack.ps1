$root = (split-path -parent $MyInvocation.MyCommand.Definition) + '\..'
$version = [System.Reflection.Assembly]::LoadFile("$root\CVQMonitor\bin\Release\CVQMonitor.dll").GetName().Version
$versionStr = "{0}.{1}.{2}-beta" -f ($version.Major, $version.Minor, $version.Revision)

Write-Host "Setting .nuspec version tag to $versionStr"

$content = (Get-Content $root\nuget\CVQMonitor.nuspec)
$content = $content -replace '\$version\$',$versionStr

$content | Out-File $root\nuget\CVQMonitor.compiled.nuspec

& $root\nuget\NuGet.exe pack $root\nuget\CVQMonitor.compiled.nuspec
