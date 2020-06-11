
######################################################
## Boxstarter Dev box install script
######################################################
#  Instructions:
#
# To run this, use Internet Exploder and go to http://boxstarter.org/package/url?https://raw.githubusercontent.com/<UPDATE>
# more instructions at http://boxstarter.org/LearnWebLauncher
######################################################


# Boxstarter Options
$Boxstarter.RebootOk=$true # Allow reboots
$Boxstarter.NoPassword=$false # Is this a machine with no login password
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot


#region Base Windows Settings
    Disable-InternetExplorerESC  #Turns off IE Enhanced Security Configuration that is on by default on Server OS versions
    Install-WindowsUpdate -AcceptEula
    Update-ExecutionPolicy Unrestricted
    Set-ExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives 
    Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst

    # Not sure that this is really necessary
    if (Test-PendingReboot) { Invoke-Reboot }
#endregion
 
#region Add features
    cinst IIS-WebServerRole -source windowsfeatures
    cinst IIS-HttpCompressionDynamic -source windowsfeatures
    cinst IIS-ManagementScriptingTools -source windowsfeatures
    cinst IIS-WindowsAuthentication -source windowsfeatures

    cinst Microsoft-Hyper-V-All -source windowsfeatures
#endregion
 
 
#region Frameworks
    cinst PowerShell
    cinst DotNet4.0
    cinst DotNet4.5
#endregion

#region Visual Studio
    cinst VisualStudio2013Professional
#endregion

#region MS Office
    
#endregion

#region Utilities
    cinst 7zip
    cinst windir
    cinst notepadplusplus
    cinst keepass
    cinst lastpass
    cinst fiddler4
    cinst sysinternals
#endregion

#region Git
    choco install githubforwindows
    choco install poshgit    
    choco install kdiff3
    choco install gitextensions
    choco install git-credential-winstore
#endregion
