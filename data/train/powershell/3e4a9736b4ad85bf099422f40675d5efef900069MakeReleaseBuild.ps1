[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$path,

  [Parameter(Mandatory=$True,Position=2)]
  [string]$releaseFolderName,

  [Parameter(Mandatory=$True,Position=3)]
  [string]$items
)

$obfPath = $path + "\bin\obf"
$destPath = $path + "\" + $releaseFolderName

# Clean and recreate destPath
if (Test-Path $destPath) { Remove-Item -Force -Recurse -Path $destPath }
New-Item -ItemType Directory -Force -Path $destPath

# Copy excecutables
foreach ($item in $items.Split(',')) {
	$copyItem = $obfPath + "\" + $item + ".exe"
	Copy-Item $copyItem $destPath
}
