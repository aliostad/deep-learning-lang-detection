<#
Fucking Packer is giving me problems with its shell, windows-shell, and powershell provisioners, so fuck it
Don't require parameters - it won't run with parameters during post install. This is just for clarity & ease of debugging
#>
[cmdletbinding()] param(
    $packerBuildName = ${env:PACKER_BUILD_NAME},
    $packerBuilderType = ${env:PACKER_BUILDER_TYPE}
)
$errorActionPreference = "Continue"
import-module $PSScriptRoot\wintriallab-postinstall.psm1

# These commands are fragile and shouldn't fail the build if they fail, so I put them in a try/catch outside of Invoke-ScriptblockAndCatch
try {
    Set-PinnedApplication -Action UnpinFromTaskbar -Filepath "C:\Program Files\WindowsApps\Microsoft.WindowsStore_2015.10.5.0_x86__8wekyb3d8bbwe\WinStore.Mobile.exe" -ErrorAction Continue
    Set-PinnedApplication -Action PinToTaskbar -Filepath "$PSHOME\Powershell.exe"
    Set-PinnedApplication -Action PinToTaskbar -Filepath "${env:SystemRoot}\system32\eventvwr.msc"
    $UserPinnedTaskBar = "${env:AppData}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
    if (test-path "$UserPinnedTaskBar\Server Manager.lnk") { rm "$UserPinnedTaskBar\Server Manager.lnk" }
}
catch {}

Invoke-ScriptblockAndCatch -scriptBlock {
    Write-EventLogWrapper "PostInstall for packer build '$packerBuildName' of type '$packerBuilderType'"
    Install-SevenZip
    Set-AutoAdminLogon -Disable
    Enable-RDP
    Install-Chocolatey

    $suoParams = @{ 
        ShowHiddenFiles = $true
        #ShowSystemFiles = $true
        ShowFileExtensions = $true
        ShowStatusBar = $true
        DisableSharingWizard = $true
        EnablePSOnWinX = $true
        EnableQuickEdit = $true
        DisableSystrayHide = $true
        DisableIEFirstRunCustomize = $true
    }
    Set-UserOptions @suoParams

    #Install-CompiledDotNetAssemblies   # Takes about 15 minutes for me 
    #Compress-WindowsInstall            # Takes maybe another 15 minutes
}
