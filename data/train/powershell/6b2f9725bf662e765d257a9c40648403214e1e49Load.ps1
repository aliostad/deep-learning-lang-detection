$PreLoad = {}

$PostLoad = {
    if (-not (Test-OMPProfileSetting -Name 'ModuleAutoCleanFrequency')) {
        Write-Output "Setting initial module clean frequency settings to occur every 8 times the module is loaded"
        Add-OMPProfileSetting -Name 'ModuleAutoCleanFrequency' -Value 8
        $AutoCleanFreq = 8
        Export-OMPProfile
    }

    $AutoCleanFreq = Get-OMPProfileSetting -Name 'ModuleAutoCleanFrequency'
    if (((Get-OMPProfileSetting -Name 'OMPRunCount') % $AutoCleanFreq) -eq 0) {
        if (Read-HostContinue -PromptQuestion 'It is time to clean up (remove) old modules, do so now?') {
            Remove-InstalledModule
        }
        else {
            Write-Output "Ok, you will be asked again after $AutoCleanFreq more sessions..."
        }
    }
}
$Config = {}
$Shutdown = {}