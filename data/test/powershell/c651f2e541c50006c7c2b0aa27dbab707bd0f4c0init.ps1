param($installPath, $toolsPath, $package, $project)

$psd = (Join-Path $toolsPath ManagePackageSources.psd1)
$psm = (Join-Path $toolsPath ManagePackageSources.psm1)

# Check if the NuGet_profile.ps1 exists and register the ManagePackageSources.psd1 module
if(!(Test-Path $profile)){
	mkdir -force (Split-Path $profile)
	New-Item $profile -Type file -Value "Import-Module ManagePackageSources -DisableNameChecking"
}
else{
	Add-Content -Path $profile -Value "`r`nImport-Module ManagePackageSources -DisableNameChecking"
}

# Copy the ManagePackageSources.psd1 and ManagePackageSources.psm1 files to the profile directory
$profileDirectory = Split-Path $profile -parent
$profileModulesDirectory = (Join-Path $profileDirectory "Modules")
$managePackageSourcesModuleDir = (Join-Path $profileModulesDirectory "ManagePackageSources")
if(!(Test-Path $managePackageSourcesModuleDir)){
	mkdir -force $managePackageSourcesModuleDir
}
copy $psd (Join-Path $managePackageSourcesModuleDir "ManagePackageSources.psd1")
copy $psm (Join-Path $managePackageSourcesModuleDir "ManagePackageSources.psm1")

# Reload NuGet PowerShell profile
. $profile

Write-Host ""
Write-Host "*************************************************************************************"
Write-Host "Congratulations! The following additional commands have been installed into your"
Write-Host "NuGet PowerShell Profile and are now always available in this console:"
Write-Host "- Get-PackageSource"
Write-Host "- Add-PackageSource"
Write-Host "- Remove-PackageSource"
Write-Host "- Set-ActivePackageSource"
Write-Host "*************************************************************************************"
Write-Host ""