# $file: need specify full path
. ".\versions.ps1"

function Unzip-MroongaPackage($workDir, $mariaDBVer, $arch) {
  $file = "$workDir\mariadb-$mariadbVer-$arch.zip"

  if ($file -eq $null) {
    Write-Host "Could not find valid built package."
    exit 1
  }
  #Load the assembly
  [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($file, $pwd)
}

cd $workDir

$platform = "win32", "winx64"

foreach ($arch in $platform)
{
  Unzip-MroongaPackage $workDir $mariaDBVer $arch
}

cd $originDir