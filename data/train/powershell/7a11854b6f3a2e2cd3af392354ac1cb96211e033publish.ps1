# Catching command line arguments
param([string]$SolutionDir)

# Define variables

$PublishPath = $SolutionDir + "\Publish"

$StagePath = $PublishPath + "\Staging"
$ConsoleStagePath = $StagePath + "\RegExTractorConsole"
$WinFormStagePath = $StagePath + "\RegExTractorWinForm"

$ConsoleReleaseDir = $SolutionDir + "\RegExTractorConsole\bin\Release"
$WinFormReleaseDir = $SolutionDir + "\RegExTractorWinFormHost\bin\Release"


$ZipPath = $PublishPath + "\ZIP"


# Remove previous data
Remove-Item -Path $PublishPath -Recurse -Force

# Recreate folders
New-Item -ItemType Directory -Force -Path $ConsoleStagePath
New-Item -ItemType Directory -Force -Path $WinFormStagePath
New-Item -ItemType Directory -Force -Path $ZipPath

# Copy RegExTractorConsole
Copy-Item $ConsoleReleaseDir\CommandLine.dll -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\Ninject.dll -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\RegExTractor.dll -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\RegExTractorConsole.exe -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\RegExTractorConsole.exe.config -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\RegExTractorModules.dll -Destination $ConsoleStagePath
Copy-Item $ConsoleReleaseDir\RegExTractorShared.dll -Destination $ConsoleStagePath

# Copy RegExTractorWinForm
Copy-Item $WinFormReleaseDir\RegExTractorWin.exe -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\Ninject.dll -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\RegExTractorWin.exe.config -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\RegExTractor.dll -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\RegExTractorModules.dll -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\RegExTractorShared.dll -Destination $WinFormStagePath
Copy-Item $WinFormReleaseDir\RegExTractorWinForm.dll -Destination $WinFormStagePath




$file = $WinFormReleaseDir + "\RegExTractor.dll"
$ass = [System.Reflection.Assembly]::LoadFile($file)
$v = $ass.GetName().Version;
$version = [string]::Format("{0}.{1:0}.{2:0}",$v.Major, $v.Minor, $v.Build)

$ZipFile = $ZipPath + "\RegExTractor_V" + $version + ".zip"
Get-ChildItem -Path $StagePath | Compress-Archive -DestinationPath $ZipFile -Verbose