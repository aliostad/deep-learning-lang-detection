$script:zipConfig = @{}
$script:zipConfig.zipLibPath = join-path ($MyInvocation.MyCommand.Path | Split-Path) "Ionic.Zip.dll"

Export-ModuleMember -Variable "zipConfig"

function New-ZipFile {
	param(
		[parameter(Mandatory=$true, Position=0)]
		[string]$zipFileName,
		[parameter(Mandatory=$true, Position=1)]
		[string[]]$directory
	)

	[System.Reflection.Assembly]::LoadFrom($script:zipConfig.zipLibPath) | out-null;
	
	$zipfile =  new-object Ionic.Zip.ZipFile

	try {
		foreach($dir in $directory) {
			$dName = split-path $dir -leaf
			$zipfile.AddDirectory($dir, $dName) | out-null
		}

		write-verbose ("Saving zip file to {0}" -f $zipFileName)
		$zipfile.Save($zipFileName)
		$zipfile.Dispose() | out-null
	} 
	catch [Exception]
	{
		write-error $_.Exception
	}
}

function Get-ZipChildItems {
	param(
		[parameter(Mandatory=$true, Position=0)]
		[string]$zipPath
	)

	[System.Reflection.Assembly]::LoadFrom($script:zipConfig.zipLibPath) | out-null;

	try {
		$zipfile = [Ionic.Zip.ZipFile]::Read($zipPath) 
		
		foreach($file in $zipfile) {
				$file.FileName
		} 
		
		$zipfile.Dispose() | out-null
	} 
	catch [Exception]
	{
		write-error $_.Exception
	}
}

function Extract-ZipFile {
	param(
		[parameter(Mandatory=$true, Position=0)]
		[string]$zipPath,
		[parameter(Mandatory=$true, Position=0)]
		[string]$destination,
		[string[]]$files
	)
	
	[System.Reflection.Assembly]::LoadFrom($script:zipConfig.zipLibPath) | out-null;
	
	try {
		$zipfile = [Ionic.Zip.ZipFile]::Read($zipPath) 
		
		foreach($file in $files) {
			$item = $zipfile[$file]
			
			if($item -ne $null) {
				$item.Extract($destination, [Ionic.Zip.ExtractExistingFileAction]::OverwriteSilently)
			}
		}
		
		$zipfile.Dispose() | out-null
	} 
	catch [Exception]
	{
		write-error $_.Exception
	}
}

function Update-ZipFile {
	param(
		[parameter(Mandatory=$true, Position=0)]
		[string]$zipPath,
		[parameter(Mandatory=$true, Position=0)]
		[string[]]$files
	)
	
	[System.Reflection.Assembly]::LoadFrom($script:zipConfig.zipLibPath) | out-null;
	
	try {
		$zipfile = [Ionic.Zip.ZipFile]::Read($zipPath) 
		
		foreach($file in $files) {
			$zipfile.UpdateFile($file,"") | out-null;
		}
		
		$zipfile.Save() | out-null
		$zipfile.Dispose() | out-null
	} 
	catch [Exception]
	{
		write-error $_.Exception
	}
}

Export-ModuleMember -Function "New-ZipFile", "Get-ZipChildItems", "Extract-ZipFile", "Update-ZipFile"