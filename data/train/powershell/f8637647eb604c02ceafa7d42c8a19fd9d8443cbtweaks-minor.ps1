$ErrorActionPreference = "Stop"

function EnsureKey {
    $item = $args[0] 
    if (!(Test-Path $item)) { New-Item $item -ItemType RegistryKey -Force | Out-Default }
}

Write-Output "== Performing minor user tweaks ==" | Out-Default

$keyExplorerOpts = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
EnsureKey $keyExplorerOpts
Write-Output "Show file extensions in Explorer" | Out-Default
Set-ItemProperty -Path $keyExplorerOpts -Name HideFileExt -Type "DWord" -Value 0 -Force | Out-Default
Write-Output "Show Run command in Start Menu" | Out-Default
Set-ItemProperty -Path $keyExplorerOpts -Name Start_ShowRun -Type "DWord" -Value 1 -Force | Out-Default
Write-Output "Show Administrative Tools in Start Menu" | Out-Default
Set-ItemProperty -Path $keyExplorerOpts -Name StartMenuAdminTools -Type "DWord" -Value 1 -Force | Out-Default

$keyConsoles = 'HKCU:\Console'
EnsureKey $keyConsoles
Write-Output "Enable Console Quick Edit mode" | Out-Default
Set-ItemProperty -Path $keyConsoles -Name QuickEdit -Type "DWord" -Value 1 -Force | Out-Default
