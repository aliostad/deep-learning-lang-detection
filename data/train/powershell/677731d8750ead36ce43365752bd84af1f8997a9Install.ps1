param($installPath, $toolsPath, $package, $project)

function CopyToOutput([System.IO.DirectoryInfo]$currentDI, [System.IO.DirectoryInfo]$targetDI,[string] $relativeDirString)
{
	foreach($contentDirItem in $currentDI.GetDirectories())
	{
		Write-Output Enumerating subdirectory $contentDirItem.Name
		CopyToOutput $contentDirItem $targetDI ($relativeDirString + $contentDirItem.Name + "\")
	}
	
	foreach($contentDirFile in $currentDI.GetFiles())
	{
		$fullFileNameToCopyStr = $targetDI.FullName + $relativeDirString + $contentDirFile.Name
		
		$fullFileToCopyFI = New-Object System.IO.FileInfo $fullFileNameToCopyStr
		if($fullFileToCopyFI.Exists)
		{
			Write-Output Deleting existing file $fullFileToCopyFI.FullName
			$fullFileToCopyFI.Delete()
		}
		if(-not $fullFileToCopyFI.Directory.Exists)
		{
			Write-Output Creating directory $fullFileToCopyFI.Directory.FullName
			$fullFileToCopyFI.Directory.Create()
		}
		
		Write-Output Copying $contentDirFile.FullName to $fullFileNameToCopyStr
		$contentDirFile.CopyTo($fullFileNameToCopyStr)
	}
}

$projectDir = (Get-Item $project.FullName).Directory

$ProjectDI = $projectDir
$InstallDI = (New-Object system.IO.DirectoryInfo $installPath)

$projectPath = $projectDir.Fullname

$installPathString = $InstallDI.FullName
$projectPathString = $ProjectDI.FullName

$ContentUnreferencedDI = [System.IO.DirectoryInfo]$InstallDI.GetDirectories("ContentUnreferenced")[0]

if($ContentUnreferencedDI -ne $null)
{
	CopyToOutput $ContentUnreferencedDI $ProjectDI "\"
}

