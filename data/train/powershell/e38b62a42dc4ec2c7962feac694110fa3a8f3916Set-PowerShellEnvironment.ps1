# Toggle regions: Ctrl + M

#region Demo setup
Write-Warning 'This is a demo script which should be run line by line or sections at a time, stopping script execution'

break

<#

    Author:      Jan Egil Ring
    Name:        Set-PowerShellEnvironment.ps1
    Description: This demo script is part of the presentation 
                 Manage your IT Pro computer using PowerShell
                 
#>

# Inspect folder structure
# The tree command output got issues in the ISE, thus we`re launching the Console Host. If PSCX was installed, we could have used Show-Tree.

Start-Process -FilePath powershell.exe -ArgumentList "-NoExit -Command tree (Resolve-Path ~\Git\ITPro-Computer\WindowsPowerShell)"

Get-ChildItem ~\Git\ITPro-Computer\WindowsPowerShell\Environments -Recurse

Get-ChildItem ~\Git\ITPro-Computer\WindowsPowerShell\*profile.ps1 | ForEach-Object {psedit $PSItem.FullName}

Get-ChildItem ~\Git\ITPro-Computer\WindowsPowerShell\Environments\All\*.ps1 | ForEach-Object {psedit $PSItem.FullName}

psedit ~\Git\ITPro-Computer\WindowsPowerShell\Environments\DEMO\setup.ps1


# Configure symbolic link for WindowsPowerShell-folder

Get-ChildItem ~\Documents

New-Item -Path ~\Documents -Name WindowsPowerShell -ItemType SymbolicLink -Target ~\Git\ITPro-Computer\WindowsPowerShell

Get-ChildItem ~\Documents

# Verify that profiles load and module autoloading works
Start-Process -FilePath powershell.exe

# Reload ISE and look at Add-ons menu