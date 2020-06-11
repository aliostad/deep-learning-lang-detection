#region Demo setup
Write-Warning 'This is a demo script which should be run line by line or sections at a time, stopping script execution'

break

<#

    Author:      Jan Egil Ring
    Name:        Initialize-Repository.ps1
    Description: This demo script is part of the presentation 
                 Manage your IT Pro computer using PowerShell

    Change log: 2016-05-25 - Updated initalization script to run on a regular Windows 10 computer - dependencies of Crayon Demo environment removed
                 
#>


#region Environment info

<#


Windows 10 Enterprise default installation with the following customizations:
-Local user (admin-privileges) created


#>

#endregion


# Increase PowerShell ISE Zoom level for demo purposes
$psISE.Options.Zoom = 140

# Create local folder for Git-repositories
 if (-not (Test-Path -Path ~\Git)) {

  New-Item -Path ~ -Name Git -ItemType Directory

 }

# Install Chocolatey
Invoke-WebRequest https://chocolatey.org/install.ps1 | Invoke-Expression

# Install Git client
C:\ProgramData\Chocolatey\choco.exe install git

# Download Git repository
$gitrepo = Join-Path -Path (Resolve-Path -Path ~\Git) -ChildPath CrayonDemo-ITPro-Computer
Start-Process -FilePath powershell.exe -ArgumentList "git --% clone https://github.com/janegilring/ITProComputer.git $gitrepo"

# Run remaining scripts from repository
dir ~\Git\CrayonDemo-ITPro-Computer
psedit ~\Git\CrayonDemo-ITPro-Computer\WindowsPowerShell\Scripts\Core\Demos\Invoke-ITProComputerDemoScripts.ps1