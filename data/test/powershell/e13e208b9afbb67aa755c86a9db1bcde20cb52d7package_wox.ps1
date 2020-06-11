# The following parameters should be passed from Visual Studio

param (
    [string]$TargetName,
    [string]$TargetDir,
    [string]$TargetPath
)

# Get path to the DotNetZip assembly and load it

$pathToAssembly = Join-Path -path $TargetDir -childpath "Ionic.Zip.dll"
[System.Reflection.Assembly]::LoadFrom($pathToAssembly)

# All files that should be included in the .wox archive

[array]$fileNames = "System.Data.SQLite.dll", "System.Data.SQLite.Linq.dll", 
    "Wox.Plugin.dll", "Wox.Plugin.Firefox.dll", "plugin.json"

# Find the path to each file

foreach ($f in $fileNames)
{
    $filePaths += @( Join-Path -path $TargetDir -childpath $f )
}

# Load built assembly and get the version

$ass = [System.Reflection.Assembly]::LoadFile($TargetPath)
$v = $ass.GetName().Version;
$version = [string]::Format("{0}.{1}.{2}",$v.Major, $v.Minor, $v.Build)

# The name of the .wox file

$name = [string]::Format("{0}_{1}.wox", $TargetName, $version)

$zipfile = new-object Ionic.Zip.ZipFile

# Add all files and directories

foreach ($f in $filePaths)
{
    $zipfile.AddFile($f, "")
}

foreach ($d in "x64", "x86")
{
    $dirpath = Join-Path -path $TargetDir -childpath $d
    $zipfile.AddDirectory($dirpath, $d)
}

# Create the .wox file

$zipfile.Save($name)
$zipfile.Dispose()