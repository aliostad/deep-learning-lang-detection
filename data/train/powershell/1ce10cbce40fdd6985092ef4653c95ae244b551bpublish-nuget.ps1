## echo . # > nul & powershell invoke-expression (get-content -raw %~dpf0 %1 %2 %3 %4 %5 %6 %7 %8 %9) & goto :EOF
ipmo coapp

$file = "..\..\output\v40\AnyCPU\Release\bin\Merged\NuGet-AnyCPU.exe"
$version = ([System.Diagnostics.FileVersionInfo]::GetVersionInfo( $file ).FileVersion)

# generate a swidtag
$swid = ( get-content .\nuget.swidtag.master -raw ) -replace '\+VERSION\+',$version 
$swidfile = ".\nuget.$version.swidtag"

#set the content of the swidtag
set-content $swidfile $swid 

#copy the file local
$versionedfile = ".\nuget-anycpu-$version.exe"
$versionedremotefile = ""

copy-item $file $versionedfile

# don't really need to copy this every time
# copy-itemex -force .\OneGet-Bootstrap.swidtag oneget:providers\oneget-bootstrap.swidtag

# copy the swidtag and the nuget.exe to the versioned locations
copy-itemex -force $swidfile oneget:providers\nuget.$version.swidtag
copy-itemex -force $versionedfile oneget:providers\nuget-anycpu-$version.exe

# copy the nuget.exe to the non-versioned ones.
echo "copy-itemex -force $versionedfile oneget:providers\nuget-anycpu.exe"
echo "copy-itemex -force $versionedfile oneget:providers\NuGet-AnyCPU.exe"
echo "copy-itemex -force $swidfile oneget:providers\nuget.swidtag"


echo "latest is at: https://oneget.org/nuget-anycpu.exe"