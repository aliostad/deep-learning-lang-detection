try {

    # Boxstarter options
    $Boxstarter.RebootOk=$true # Allow reboots?
    $Boxstarter.NoPassword=$false # Is this a machine with no login password?
    $Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

    # Basic setup
    Update-ExecutionPolicy Unrestricted
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
    Enable-RemoteDesktop
    Disable-InternetExplorerESC
    Disable-UAC
    Set-TaskbarOptions -Size Small -UnLock -Dock Top

    if (Test-PendingReboot) { Invoke-Reboot }

    # Update Windows and reboot if necessary
    Install-WindowsUpdate -AcceptEula
    if (Test-PendingReboot) { Invoke-Reboot }

    cinstm DotNet3.5 # Not automatically installed with VS 2013. Includes .NET 2.0. Uses Windows Features to install.
    if (Test-PendingReboot) { Invoke-Reboot }

    cinst DotNet4.5
    if (Test-PendingReboot) { Invoke-Reboot }
    cinst DotNet4.5.1
    if (Test-PendingReboot) { Invoke-Reboot }
    cinst DotNet4.5.2
    if (Test-PendingReboot) { Invoke-Reboot }

    cinst Microsoft-Hyper-V-All -source windowsfeatures

    cinst IIS-WebServerRole -source windowsfeatures
    cinst IIS-WebServerManagementTools -source windowsfeatures
    cinst IIS-ManagementConsole -source windowsfeatures

    cinst IIS-HttpCompressionDynamic -source windowsfeatures
    cinst IIS-ManagementScriptingTools -source windowsfeatures
    cinst IIS-WindowsAuthentication -source windowsfeatures

    cinst IIS-RequestFiltering -source windowsfeatures
    cinst IIS-HttpRedirect -source windowsfeatures
    
    cinst IIS-ISAPIFilter -source windowsfeatures
    cinst IIS-ISAPIExtensions -source windowsfeatures
    cinst IIS-NetFxExtensibility -source windowsfeatures
    cinst IIS-ASPNET -source windowsfeatures
    
    cinst IIS-NetFxExtensibility45 -source windowsfeatures
    cinst NetFx4Extended-ASPNET45 -source windowsfeatures
    cinst IIS-ASPNET45 -source windowsfeatures

    #Enable ASP.NET on win 7/2008R2
    ."$env:windir\microsoft.net\framework\v4.0.30319\aspnet_regiis.exe" -i
    

    Write-ChocolateySuccess 'frozenbytes.baseline.dev.core'
} catch {
  Write-ChocolateyFailure 'frozenbytes.baseline.dev.core' $($_.Exception.Message)
  throw
}