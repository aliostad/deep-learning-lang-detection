$wpa81vsix = "http://sqlite.org/2015/sqlite-wp81-winrt-3080801.vsix"
$win81vsix = "http://sqlite.org/2015/sqlite-winrt81-3080801.vsix"

#################################################
# Download and expand Sqlite VSIX files
#################################################
$tmpPath = ".tmp"
mkdir $tmpPath | Out-Null
$wpa81 = "$tmpPath\wpa81.vsix"
$win81 = "$tmpPath\win81.vsix"

# WindowsPhone
Write-Host "Retrieving Windows Phone binaries"
$wpa81Tmp = Join-Path $tmpPath wpa81
mkdir $wpa81tmp | Out-Null
Invoke-WebRequest $wpa81vsix -OutFile $wpa81
Expand-Archive $wpa81 -OutputPath $wpa81Tmp -showProgress

# Windows
Write-Host "Retrieving Windows RT binaries"
$win81Tmp = Join-Path $tmpPath win81
mkdir $win81Tmp | Out-Null
Invoke-WebRequest $win81vsix -OutFile $win81
Expand-Archive $win81 -OutputPath $win81Tmp -showProgress

#################################################
# Setup nuget structure
#################################################
$win81out = "nuget\build\win8"
copy $win81Tmp\Redist\Retail $win81out -Recurse
mv $win81out\Retail $win81out\native

$wpa81out = "nuget\build\wpa81"
copy $wpa81Tmp\Redist\Retail $wpa81out -Recurse
mv $wpa81out\Retail $wpa81out\native

nuget pack nuget\sqlite-native.nuspec -NonInteractive -NoPackageAnalysis