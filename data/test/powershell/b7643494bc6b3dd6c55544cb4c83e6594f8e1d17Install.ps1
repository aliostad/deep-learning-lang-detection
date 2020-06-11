[CmdletBinding()]
param (
	[Parameter(Mandatory=$true,ParameterSetName="DisplayInfo")][switch]$DisplayInfo,
	[Parameter(Mandatory=$true,ParameterSetName="InitializeGit")][switch]$InitializeGit,
	[Parameter(Mandatory=$true,ParameterSetName="PreReqCheck")][switch]$PreReqCheck,
	[Parameter(Mandatory=$true,ParameterSetName="PowerShellConsoleUserFolders")][switch]$PowerShellConsoleUserFolders,
	[Parameter(Mandatory=$true,ParameterSetName="Specific")][switch]$Specific,
	[Parameter(Mandatory=$true,ParameterSetName="Mixed")][switch]$Mixed,
	[Parameter(Mandatory=$true,ParameterSetName="Finalize")][switch]$Finalize,
	[Parameter(ParameterSetName="Finalize")][switch]$StartAfterInstall,
	[Parameter(ParameterSetName="Finalize")][switch]$AutomatedReinstall
)

Set-StrictMode -Version Latest

trap {
	(Get-Host).SetShouldExit(1)
}

. "..\Load Dependencies.ps1"

$processInstallStepFiles = {
	param ($Folder)
	Push-Location $Folder
	Get-ChildItem -Filter *.ps1 -File | Sort-Object Name | % { & $_.FullName }
	Pop-Location
}

switch ($PSCmdlet.ParameterSetName)
{
	"DisplayInfo" {
		Write-InstallMessage -EnterNewScope "Install Information"
		Write-InstallMessage -Type Info "Install Path: $($PowerShellConsoleConstants.InstallPath)"
		Write-InstallMessage -Type Info "Installed Version: $($PowerShellConsoleConstants.Version.InstalledVersion)"
		Write-InstallMessage -Type Info "Installing Version: $($PowerShellConsoleConstants.Version.CurrentVersion)"
	}
	"InitializeGit" {
		Write-InstallMessage -EnterNewScope "Initializing local Git repositories"
		$consoleGitHubSyncerInit = Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConsoleGitHubSyncer -ArgumentList "-InitializeRepositories $($PowerShellConsoleConstants.InstallPath)" -PassThru -NoNewWindow -Wait
		if ($consoleGitHubSyncerInit.ExitCode -ne 0) {
			Write-InstallMessage -Type Error "Failed to initialize Git repositories."
			Get-Host | % SetShouldExit $consoleGitHubSyncerInit.ExitCode
		}
	}
	"PreReqCheck" { 
		Write-InstallMessage -EnterNewScope "Checking for prerequisites"
		$failedPrerequisites = & ".\Prerequisites Check.ps1"
		if ($failedPrerequisites -ge 1) {
			Write-InstallMessage -Type Error "Prerequisites not met. Exiting installation."
			Get-Host | % SetShouldExit $failedPrerequisites
		}
		Write-InstallMessage -Type Success "All prerequisites met"
	}
	"PowerShellConsoleUserFolders" {
		Write-InstallMessage -EnterNewScope "Configuring PowerShell Console User Folders"
		& $processInstallStepFiles "PowerShell Console User Folders"
		Write-InstallMessage -Type Success "Configuring PowerShell Console User Folders Done"
	}
	"Specific" {
		Write-InstallMessage -EnterNewScope ("Configuring {0} Bitness Settings" -f $PowerShellConsoleConstants.ProcessArchitecture)

		& $processInstallStepFiles "Specific Platform\Unified"		
		& $processInstallStepFiles "Specific Platform\$($PowerShellConsoleConstants.ProcessArchitecture)"
		
		Write-InstallMessage -Type Success ("Configuring {0} Bitness Done" -f $PowerShellConsoleConstants.ProcessArchitecture)
	}
	"Mixed"{
		Write-InstallMessage -EnterNewScope "Configuring Mixed Bitness Settings"
		& $processInstallStepFiles "Mixed Platform"
		Write-InstallMessage -Type Success "Configuring Mixed Bitness Done"
	}
	"Finalize" {
		Write-InstallMessage -EnterNewScope "Finalizing installation"
		& $processInstallStepFiles "Finalization"
		Write-InstallMessage -Type Success "Finalization done"

		Write-Host
		Write-InstallMessage -Type Success "Completed installation!"

		if ($StartAfterInstall) {
			Write-Host
			Write-InstallMessage -Type Success "Attempting to start PowerShell Console..."
			Start-Process -FilePath $PowerShellConsoleConstants.Executables.ConEmu -ArgumentList "/cmd {PowerShell}"
		}

		Write-Host
	}
}