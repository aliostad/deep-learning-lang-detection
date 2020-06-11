$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
	$CheckExistenceCode = { 
		$CurrentAzCopy = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Azure Storage Tools*"}
		$CurrentAzCopy
	}
	$CheckExistenceJob = Start-Job -ScriptBlock $CheckExistenceCode

	$AzCopyMsiPath = getConfValue "AzCopyMsiPath"
	if( -not [bool] $AzCopyMsiPath ) {
		$AzCopyMsiPath = read-host " The path of AzCopy installer is missing, please enter the path"
		setConfValue "AzCopyMsiPath" $AzCopyMsiPath
	}
	else {
		if( -not (yesOrNo( "The AzCopy installer located at $AzCopyMsiPath, correct?"))) {
			$AzCopyMsiPath = read-host " Please enter the new path of AzCopy installer"
			setConfValue "AzCopyMsiPath" $AzCopyMsiPath
		}
	}
	if ((Test-Path $AzCopyMsiPath.Trim("`"")) -eq $false) {
        throw "The path of AzCopy installer is wrong."
    }
	
	log "Wait for the check of installed AzCopy."
	$Waitjob = Wait-Job $CheckExistenceJob
	$CurrentAzCopy = Receive-Job $CheckExistenceJob
	Remove-Job -Job $CheckExistenceJob
	if (-not [bool] $CurrentAzCopy) {
		throw "Please install an old version AzCopy before start the upgrade test."
	}
	else {
		if( -not (yesOrNo( "The current AzCopy version is $($CurrentAzCopy.Version), is it an old version AzCopy?"))) {
			throw "Please install an old version AzCopy before start the upgrade test."
		}
	}
}
finally {
    popd
}