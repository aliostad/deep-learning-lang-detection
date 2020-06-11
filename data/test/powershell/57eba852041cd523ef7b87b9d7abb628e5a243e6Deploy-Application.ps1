<#
.SYNOPSIS
	This script performs the installation or uninstallation of an application(s).  
.DESCRIPTION
	The script is provided as a template to perform an install or uninstall of an application(s). 
	The script either performs an "Install" deployment type or an "Uninstall" deployment type.
	The install deployment type is broken down in to 3 main sections/phases: Pre-Install, Install, and Post-Install.
	The script dot-sources the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.
	To access the help section,
.EXAMPLE
	Deploy-Application.ps1
.EXAMPLE
	Deploy-Application.ps1 -DeploymentMode "Silent"
.EXAMPLE
	Deploy-Application.ps1 -AllowRebootPassThru -AllowDefer
.EXAMPLE
	Deploy-Application.ps1 Uninstall 
.PARAMETER DeploymentType
	The type of deployment to perform. [Default is "Install"]
.PARAMETER DeployMode
	Specifies whether the installation should be run in Interactive, Silent or NonInteractive mode.
	Interactive = Default mode
	Silent = No dialogs
	NonInteractive = Very silent, i.e. no blocking apps. Noninteractive mode is automatically set if an SCCM task sequence or session 0 is detected.
.PARAMETER AllowRebootPassThru
	Allows the 3010 return code (requires restart) to be passed back to the parent process (e.g. SCCM) if detected from an installation.
	If 3010 is passed back to SCCM a reboot prompt will be triggered. 
.PARAMETER TerminalServerMode
	Changes to user install mode and back to user execute mode for installing/uninstalling applications on Remote Destkop Session Host/Citrix servers
.NOTES
.LINK 
	Http://psappdeploytoolkit.codeplex.com
"#>
Param (
	[ValidateSet("Install","Uninstall")] 
	[string] $DeploymentType = "Install",
	[ValidateSet("Interactive","Silent","NonInteractive")]
	[string] $DeployMode = "Interactive",
	[switch] $AllowRebootPassThru = $false,
	[switch] $TerminalServerMode = $false
)

#*===============================================
#* VARIABLE DECLARATION
Try {
#*===============================================

#*===============================================
# Variables: Application

$appVendor = "Microsoft"
$appName = "Office"
$appVersion = "2013"
$appArch = ""
$appLang = "SV"
$appRevision = "01"
$appScriptVersion = "1.0.0"
$appScriptDate = "08/08/2014"
$appScriptAuthor = "Daniel Classon"

# Custom Variables

$officeExecutables = @("excel.exe", "groove.exe", "onenote.exe", "infopath.exe", "onenote.exe", "outlook.exe", "mspub.exe", "powerpnt.exe", "winword.exe", "winproj.exe" ,"visio.exe")
#$dirOffice = Join-Path "$envProgramFilesX86" "Microsoft Office"

#*===============================================
# Variables: Script - Do not modify this section

$deployAppScriptFriendlyName = "Deploy Application"
$deployAppScriptVersion = [version]"3.1.5"
$deployAppScriptDate = "08/01/2014"
$deployAppScriptParameters = $psBoundParameters

# Variables: Environment
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
# Dot source the App Deploy Toolkit Functions
."$scriptDirectory\AppDeployToolkit\AppDeployToolkitMain.ps1"
# Handle ServiceUI invocation
If ($serviceUIExitCode -ne $null) { Exit-Script $serviceUIExitCode }

#*===============================================
#* END VARIABLE DECLARATION
#*===============================================

#*===============================================
#* PRE-INSTALLATION
If ($deploymentType -ne "uninstall") { $installPhase = "Pre-Installation"
#*===============================================


	# Show Welcome Message, close Internet Explorer if required, allow up to 3 deferrals, verify there is enough disk space to complete the install and persist the prompt
	#Show-InstallationPrompt -Message "Office 2013 will now be installed without any errors" -ButtonRightText "Yes, it will" -Icon Information -NoWait
	Show-InstallationWelcome -CloseApps "iexplore,communicator,ucmapi,excel,groove,onenote,infopath,onenote,outlook,mspub,powerpnt,winword,winproj,visio" -CheckDiskSpace -PersistPrompt

	# Show Progress Message (with the default message)
	Show-InstallationProgress

#*===============================================
#* INSTALLATION 
$installPhase = "Installation"
#*===============================================

	# Uninstall Office 2010
		ForEach ($officeExecutable in $officeExecutables) {
			If (Test-Path "$envProgramFilesX86\Microsoft Office\Office14\$officeExecutable") { 
                Show-InstallationProgress "Avinstallerar Office 2010"
				Write-Log "Microsoft Office 2010 was detected. Will be uninstalled."
				Execute-Process -FilePath "CScript.Exe" -Arguments "`"$dirSupportFiles\OffScrub10.vbs`" ClientAll /S /Q /NoCancel" -WindowStyle Hidden -IgnoreExitCodes "1,2,3"
				Break
			}
		}
	
	# Install Office 2013
	Show-InstallationProgress "Installerar Office 2013..."
	Execute-Process -FilePath "setup.exe" 

#*===============================================
#* POST-INSTALLATION
$installPhase = "Post-Installation"
#*===============================================

	# Uninstall Lync 2010
	Execute-Process -FilePath "msiexec.Exe" -Arguments "/x {71C6D199-5B8E-41E7-BA36-D99F66E0072E} /qn REBOOT=ReallySuppress" -ContinueOnError $true
    Show-InstallationProgress "Avinstallerar Lync 2010"

	# Display a message at the end of the install

$timeout = new-timespan -Minutes 10
$sw = [diagnostics.stopwatch]::StartNew()
while ($sw.elapsed -lt $timeout){
    if (Test-Path "$envProgramFilesX86\Microsoft Office\Office15\lync.exe"){
        Show-InstallationPrompt -Message "Office 2013 är nu installerat!" -buttonRightText "Ok" -Icon Information -NoWait
        return
        }
 
    Show-InstallationProgress "Verifierar att Office 2013 är installerat..."
    Start-Sleep -seconds 5
}


#*===============================================
#* UNINSTALLATION
} ElseIf ($deploymentType -eq "uninstall") { $installPhase = "Uninstallation"
#*===============================================

	# Show Welcome Message, close Internet Explorer if required with a 60 second countdown before automatically closing
	Show-InstallationWelcome -CloseApps "iexplore" -CloseAppsCountdown "60"

	# Show Progress Message (with the default message)
	Show-InstallationProgress

	# Perform uninstallation tasks here
	Execute-Process -FilePath "setup.exe /uninstall"

#*===============================================
#* END SCRIPT BODY
} } Catch { $exceptionMessage = "$($_.Exception.Message) `($($_.ScriptStackTrace)`)"; Write-Log "$exceptionMessage"; Show-DialogBox -Text $exceptionMessage -Icon "Stop"; Exit-Script -ExitCode 1 } # Catch any errors in this script 
Exit-Script -ExitCode 0 # Otherwise call the Exit-Script function to perform final cleanup operations
#*===============================================
