param($installPath, $toolsPath, $package, $project) 

$path = [System.IO.Path]
$target = $path::GetDirectoryName($project.FileName)

copy $path::Combine($target, "web.config") -destination $path::Combine($target, "web.config.backup")
copy $path::Combine($toolsPath, "transform.proj") -destination $path::Combine($target, "transform.proj")
copy $path::Combine($toolsPath, "web.transform.config") -destination $path::Combine($target, "web.transform.config")
$transform = $path::Combine($target, "transform.proj")
Invoke-Expression "$env:systemroot\Microsoft.Net\Framework\v4.0.30319\MSBuild.exe $transform /t:transform"
