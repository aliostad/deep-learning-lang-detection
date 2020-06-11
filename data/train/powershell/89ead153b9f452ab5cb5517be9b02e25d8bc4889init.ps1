param($installPath, $toolsPath, $package, $project)

$psd = (Join-Path $toolsPath DiscoverPackageSources.psd1)
$psm = (Join-Path $toolsPath DiscoverPackageSources.psm1)

# Check if the NuGet_profile.ps1 exists and register the DiscoverPackageSources.psd1 module
if(!(Test-Path $profile)){
	mkdir -force (Split-Path $profile)
	New-Item $profile -Type file -Value "Import-Module DiscoverPackageSources -DisableNameChecking"
}
else{
	if (!(Select-String "DiscoverPackageSources" -Quiet $profile)) {
		Add-Content -Path $profile -Value "`r`nImport-Module DiscoverPackageSources -DisableNameChecking"
	}
}

# Copy the DiscoverPackageSources.psd1 and DiscoverPackageSources.psm1 files to the profile directory
$profileDirectory = Split-Path $profile -parent
$profileModulesDirectory = (Join-Path $profileDirectory "Modules")
$managePackageSourcesModuleDir = (Join-Path $profileModulesDirectory "DiscoverPackageSources")
if(!(Test-Path $managePackageSourcesModuleDir)){
	mkdir -force $managePackageSourcesModuleDir
}
copy $psd (Join-Path $managePackageSourcesModuleDir "DiscoverPackageSources.psd1")
copy $psm (Join-Path $managePackageSourcesModuleDir "DiscoverPackageSources.psm1")

# Reload NuGet PowerShell profile
. $profile

Write-Host ""
Write-Host "*************************************************************************************"
Write-Host "Congratulations! The following additional commands have been installed into your"
Write-Host "NuGet PowerShell Profile and are now always available in this console:"
Write-Host "- Get-PackageSource"
Write-Host "- Add-PackageSource"
Write-Host "- Add-DebuggingSource"
Write-Host "- Discover-PackageSources"
Write-Host "*************************************************************************************"
Write-Host ""