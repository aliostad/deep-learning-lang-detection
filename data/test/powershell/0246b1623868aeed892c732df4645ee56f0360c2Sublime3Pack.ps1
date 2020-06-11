#Load Boxstarter.Chocolatey
Import-Module Boxstarter.Chocolatey

Update-ExecutionPolicy Unrestricted

# Load custom functions .\Common\functions
. .\Common\functions\Install-CommonFunctions.ps1

Write-Host Get-Module Boxstarter*

#Get project directory name
$projectPackage = $(Get-Location | Split-Path -Leaf)
$packageInstallText = $projectPackage + ' software package'

if (Install-NeededFor $packageInstallText) 
{
	#Check if chocolatey is installed 
	if( Install-ChocoOnlyIfNotPreviouslyInstalled )
	{
		write-host 'Installing ' + $packageInstallText
		# Could call other install scrtips here or call cinst package or Import Boxstarter and install
  		#& another.ps1
  		#cinst packages.config -y
  		#
  		choco install sublimetext3 -y
		choco install sublimetext3.packagecontrol -y

	}else
	{
		write-host 'We have encountered a problem installing Chocolatey'
	}
  
}else
{
  write-host 'Installation cancelled'
}