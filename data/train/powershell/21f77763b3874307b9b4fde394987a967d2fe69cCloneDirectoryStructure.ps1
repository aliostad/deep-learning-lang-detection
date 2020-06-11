#
# Recursively clones a directory structure (and certain files in it - if desired)
#

function Prompt-Host{
param([string]$message)
    while($true){
        Write-Host "$message (Y / N)?"
        $res = Read-Host

        if ($res -ieq "Y"){
            return $true
        }
        elseif ($res -ieq "N"){
            return $false
        }
    }
}
function CopyFiles{
param([string]$currDir, [string[]]$fileExts)

    # Enumerate directories within this directory
    $dirs = [System.IO.Directory]::EnumerateDirectories($currDir)

    # Enumerate files within this directory and filter
    $files = Get-Item "$currDir\*"
    $files = $files | Where-Object { $_.Extension.Replace(".", "") -in $fileExts }

    # Loop through files and copy ones matching specified extensions
    foreach ($file in $files){
        $newPath = $file.FullName.Replace($rootPath, $destPath)
        $newPathDir = [System.IO.Path]::GetDirectoryName($newPath)
        if (![System.IO.Directory]::Exists($newPathDir)){
            $noop = [System.IO.Directory]::CreateDirectory($newPathDir)
        }
        if (![System.IO.File]::Exists($newPath)){
            "Copying '" + $file.FullName.Replace($rootPath, "") + "' to '$newPath'..."
            [System.IO.File]::Copy($file.FullName, $newPath)
        }
        else{
            if (Prompt-Host ("File '" + $file.FullName + "' exists!  Overwrite?")){
                [System.IO.File]::Copy($file.FullName, $newPath, $true)
            }
        }
    }

    # Loop through dirs and recurse
    foreach ($dir in $dirs){
        CopyFiles $dir $fileExts
    }
}

$rootPath = "C:\Music"                # Root of directory structure to copy
$destPath = "D:\MusicArtwork"         # Path where directory structure clone will be output
$fileExts = @("jpg", "jpeg", "png")   # File extensions to copy into new directory structure

# Kick it off
CopyFiles $rootPath $fileExts