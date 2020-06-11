if ($useNightly -eq $TRUE) {
  $nightly = "source-nightly.zip"
  if (Test-Path -path "$nightly") {
    $zipname = "$nightly"
  } else {
    Write-Host "Not found valid nightly package source."
    exit 1
  }
} else {
  $stable = "source.zip"
  if (Test-Path -path "$stable") {
    $zipname = "$stable"
  } else {
    Write-Host "Not found valid package source."
    exit 1
  }
}

$file = $(Get-ChildItem $zipname).FullName

#Load the assembly
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($file, $pwd)