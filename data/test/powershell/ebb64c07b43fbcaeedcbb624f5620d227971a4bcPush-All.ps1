# Pushes all packages in the Drop folder.

$nuget = Get-ChildItem NuGet.exe
$dropDir = [System.IO.Directory]::CreateDirectory("Drop") 
$apiKey = $apiKey = Get-Content apikey.txt

# Push all extensions
foreach ($package in (Get-ChildItem Drop -Filter *.nupkg))
{
	$progress++

	Write-Progress -Activity "Publishing NETFx" -Status ("uploading package " + $package.Name) -PercentComplete $progress
	&($nuget.FullName) "push" -source http://packages.nuget.org/v1/ $package.FullName $apiKey
}

Write-Progress -Activity "Publishing NETFx" -Status "Completed" -Completed $true
