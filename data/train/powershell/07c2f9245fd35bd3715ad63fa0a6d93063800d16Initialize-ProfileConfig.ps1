function Initialize-ProfileConfig {
    if (Test-Path Variable:Global:ProfileConfig) {
        Remove-Variable -Name ProfileConfig -Scope Global -Force
    }

    if (Test-Path $profileConfigFile) {
        try {
            $importedProfileConfig =  Get-Content -Path $profileConfigFile -Raw | ConvertFrom-Json
        }
        catch {
            Write-Host -ForegroundColor Red "Error loading profile config file: $($_.Exception.Message)"
            
            $backupConfigFile = [System.IO.Path]::ChangeExtension($profileConfigFile, "bak")
            Move-Item -Path $profileConfigFile -Destination $backupConfigFile
            Write-Host -ForegroundColor Red "Moving corrupt config file to: $backupConfigFile"
            
            $importedProfileConfig = $null
        }
    } else {
        $importedProfileConfig = $null
    }

    $newProfileConfig = New-ProfileConfig -OverrideProfileConfig $importedProfileConfig
    New-Variable -Name ProfileConfig -Description "Contains configuration global information for the PowerShell Console" -Value $newProfileConfig -Scope Global -Option Readonly

    $backgroundSaveTask = { Save-ProfileConfig -Quiet }
    $Global:OnIdleScriptBlockCollection += $backgroundSaveTask
    $ExecutionContext.SessionState.Module.OnRemove = $backgroundSaveTask
}