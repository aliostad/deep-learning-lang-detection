#
# ChocolateyPackAndPushTask.ps1
#

# Get inputs.
Trace-VstsEnteringInvocation $MyInvocation

$dropFolderPath = Get-VstsInput -Name dropFolderPath -Require
$nuspecFileName = Get-VstsInput -Name nuspecFileName -Require
$chocoRepo = Get-VstsInput -Name chocoRepo -Require
$apiKey = Get-VstsInput -Name apiKey -Require
$chocoForce = Get-VstsInput -Name chocoForce -Require -AsBool
$chocoPackOnly = Get-VstsInput -Name chocoPackOnly -Require -AsBool

Write-Host "Starting ChocolateyPackAndPushTask"

try {
	Write-Host "Location : $dropFolderPath"
	Set-Location "$dropFolderPath"

	# Delete all nupkg
	Remove-Item "\*.nupkg"

	# Choco pack
	Write-Host "Attempting to pack .\$nuspecFileName"
	choco pack ".\$nuspecFileName"

	# Get new item
	$item = Get-ChildItem "*.nupkg" | Select -First 1

	# Choco push
	if (-not $chocoPackOnly)	{
		Write-Host "Attempting to push $item to source $chocoRepo"
		if ($chocoForce) {
			Write-Host "Launch command "$item" -s "$chocoRepo" -k ********** -f"
			choco push "$item" -s "$chocoRepo" -k $apiKey -f
		}
		else {
			Write-Host "Launch command "$item" -s "$chocoRepo" -k **********"
			choco push "$item" -s "$chocoRepo" -k $apiKey
		}
	}
	else {
		Write-Host "choco push command was skipped"
	}
}
catch {
    Write-Error $_.Exception.Message
}
finally {
	Trace-VstsLeavingInvocation $MyInvocation
}

Write-Host "Ending ChocolateyPackAndPushTask"