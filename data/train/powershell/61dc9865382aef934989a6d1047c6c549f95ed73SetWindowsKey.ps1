# This script takes the Windows Product Key as an argument. Checks it for validity and then installs the key
Param(
	[Parameter(Mandatory=$True)]
	[ValidatePattern("^\S{5}-\S{5}-\S{5}-\S{5}-\S{5}")]
	[string]$ProvidedLicenseKey
)
$Windows = Get-WmiObject -Class SoftwareLicensingService
Try 
{
	$Windows.InstallProductKey($ProvidedLicenseKey) | Out-Null
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	Write-Error $ErrorMessage
	Write-Host "There was an error installing the key"
	Break
}
$Windows.RefreshLicenseStatus() | Out-Null
Write-Host "License installed successfully"
