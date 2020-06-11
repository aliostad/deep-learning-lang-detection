# Toggle regions: Ctrl + M

#region Demo setup
Write-Warning 'This is a demo script which should be run line by line or sections at a time, stopping script execution'

break

<#

    Author:      Jan Egil Ring
    Name:        Invoke-ITProComputerDemoScripts.ps1
    Description: This demo script is part of the presentation 
                 Manage your IT Pro computer using PowerShell
                 
#>

# Scheduled jobs for repetitive tasks
psedit "~\Git\ITPro-Computer\WindowsPowerShell\Scripts\Core\Jobs\Register-ScheduledJob.ps1"

# Option 1: Manual configuration
psedit "~\Git\ITPro-Computer\WindowsPowerShell\Scripts\Core\Computer setup\Customizations.ps1"

# Option 2: Declarative configuration
psedit "~\Git\ITPro-Computer\WindowsPowerShell\Scripts\Core\DSC\Set-DSCConfiguration.ps1"

# Environment configuration
psedit "~\Git\ITPro-Computer\WindowsPowerShell\Scripts\Core\Computer setup\Set-PowerShellEnvironment.ps1"