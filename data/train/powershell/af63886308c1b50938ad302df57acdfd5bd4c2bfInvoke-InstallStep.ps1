function Invoke-InstallStep {
	[CmdletBinding()]
	param (
		[switch]$EnterNewScope,
		[Parameter(Mandatory=$true)]$InstallMessage,
		[Parameter(Mandatory=$true)]$InstallStep
	)

	$stepError = $null
	try {
		if ($global:InsideInstallStep) { Write-Host }
		Write-Host -NoNewline ("{0}$InstallMessage... " -f ("`t" * $global:MessageScope))
		$global:InsideInstallStep = $true

		& $InstallStep
	}
	catch {
		$stepError = $_
	}

	if (-not $global:InsideInstallStep) { Write-Host; Write-Host -NoNewline ("{0}... " -f ("`t" * $global:MessageScope)) }
	if ($null -ne $stepError) {
		Write-Host -ForegroundColor Red "ERROR!"
		throw $stepError
	}
	Write-Host -ForegroundColor Green "Done!"
	
	$global:InsideInstallStep = $false

	if ($EnterNewScope) {
		$global:MessageScope++
	}
}