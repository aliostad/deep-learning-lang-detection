$PreLoad = {}
$PostLoad = {
    if (-not (Test-OMPProfileSetting -Name 'ModuleAutoUpgradeFrequency')) {
        Write-Output "Setting initial module upgrade frequency settings to occur every 7 times the module is loaded"
        Write-Output "Modify your json profile to change this frequency."
        Add-OMPProfileSetting -Name 'ModuleAutoUpgradeFrequency' -Value 7
        Export-OMPProfile
    }

    $AutoUpgradeFreq = Get-OMPProfileSetting -Name 'ModuleAutoUpgradeFrequency'
    $RunCount = Get-OMPProfileSetting -Name 'OMPRunCount'
    if (((Get-OMPProfileSetting -Name 'OMPRunCount') % $AutoUpgradeFreq) -eq 0) {
        if (Read-HostContinue -PromptQuestion 'It is time to run module upgrades, do so now?') {
            Upgrade-InstalledModule
        }
        else {
            Write-Output "Ok, you will be asked again after $AutoUpgradeFreq more sessions..."
        }
    }
}
$Config = {}
$Shutdown = {}
$UnLoad = {
    Remove-OMPProfileSetting -Name 'ModuleAutoUpgradeFrequency'
}