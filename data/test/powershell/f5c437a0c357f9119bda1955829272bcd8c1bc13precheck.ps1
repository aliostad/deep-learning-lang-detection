$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

function findAndSaveNewAzCopyPath([ref]$AzCopyPath) {
	log "Searching for the AzCopy installed..."
	$CurrentAzCopy = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Azure Storage Tools*"}
	if( -not [bool] $CurrentAzCopy ) {
		throw "Please install the AzCopy and try again."
	}
	$AzCopyPath.Value = [string]$CurrentAzCopy.InstallLocation + "AzCopy\AzCopy.exe"
	log "Found AzCopy at $($AzCopyPath.Value)"
	setConfValue "AzCopyPath" ($AzCopyPath.Value)
}

try {
	$AzCopyPath = getConfValue "AzCopyPath"
	if( -not [bool] $AzCopyPath ) {
		findAndSaveNewAzCopyPath ([ref]$AzCopyPath)
	}
	else {
		if( -not (yesOrNo( "AzCopyPath found in the configuration file, the path is $AzCopyPath, is that right?"))) {
			findAndSaveNewAzCopyPath ([ref]$AzCopyPath)
		}
	}
	$AccountName = getConfValue "AccountName"
	$AccountKey = getConfValue "AccountKey"
    if ((Test-Path $AzCopyPath.Trim("`"")) -eq $false) {
        throw "The AzCopy.exe is missing"
    }
}
finally {
    popd
}