function Unzip-StudioFiles {
	if($args.Count -lt 2){
		"Usage: unzip-studiofiles \\janus\studio_work \\janus\studio_work"
		return
	}
	
	$source = $args[0]
	$dest = $args[1]
	if((Does-FolderExist -Path $source) -eq $false){
		$message = "Source does not exist, please check now exiting: " + $source
		Log-Error $message
		return
	}

	if((Does-FolderExist -Path $dest) -eq $false){
		$message = "Dest does not exist, please check now exiting: " + $dest
		Log-Error $message
		return
	}
	
	$zipList = Get-Zips $source
	if($zipList.Count -lt 1){
		$nothingtodo = "No zips found, nothing to do."
		Log-Info -Message $nothingtodo
		return
	}
	
	foreach($zip in $zipList){
		if((Is-ZipGood -Path $zip) -eq $false){
			$corruptzip = "Corrupt zip detected please check: " + $zip
			Log-Error $corruptzip
			continue
		}
		
		if((Is-FilenameCorrect -Path $zip) -eq $false){
			$badzipfilenamemessage = "Expect filename like State__jobid.zip please check: " + $zip
			Log-Error $badzipfilenamemessage
			continue
		}
		
		Unzip-SingleFile -Source $zip -Dest $dest
		Delete-SingleFile -Source $zip
		Log-Info -Message "Unzipped and deleted file: " + $zip
	}
}
