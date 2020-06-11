##################################################
# Resosurces:
## ServerManager Module: http://technet.microsoft.com/en-us/library/cc732263.aspx
## NetSecurity Module: http://technet.microsoft.com/en-us/library/hh831755.aspx
## Others:
## http://www.iis.net/learn/manage/remote-administration/remote-administration-for-iis-manager
## http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/12/weekend-scripter-use-powershell-to-easily-modify-registry-property-values.aspx
## http://www.iis.net/learn/install/web-platform-installer/web-platform-installer-v4-command-line-webpicmdexe-rtw-release
##################################################

# Variables
$ScriptRoot = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$additionalFeatures = @('Web-Mgmt-Service', 'Web-Asp-Net45', 'Web-Dyn-Compression', 'Web-Scripting-Tools')
$webPiProducts = @('WDeployPS', 'UrlRewrite2')

# Import Modules
Import-Module -Name ServerManager
Import-Module -Name NetSecurity
Import-Module -Name Microsoft.PowerShell.Management

# Add Windows Features
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -LogPath "$env:TEMP\init-webservervm_webserver_install_log_$((get-date).ToString("yyyyMMddHHmmss")).txt"
foreach($feature in $additionalFeatures) { 
    
    if(!(Get-WindowsFeature | where { $_.Name -eq $feature }).Installed) { 

        Install-WindowsFeature -Name $feature -LogPath "$env:TEMP\init-webservervm_feature_$($feature)_install_log_$((get-date).ToString("yyyyMMddHHmmss")).txt"   
    }
}

# Make Sure That Remote Connection is Enabled
if((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server\ -Name EnableRemoteManagement).EnableRemoteManagement -eq 0) { 
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server\ -Name EnableRemoteManagement -Value 1   
}

# Set WMSvc to Automatic Startup
Set-Service -Name WMSvc -StartupType Automatic

# Check If WMSvc (Web Management Service) is running
if((Get-Service WMSvc).Status -ne 'Running') { 
    Start-Service WMSvc
}

# Install WebPI Products
& "$ScriptRoot\WebPICMD.exe" /Install /Products:"$($webPiProducts -join ',')" /AcceptEULA /Log:"$env:TEMP\webpi_products_install_log_$((get-date).ToString("yyyyMMddHHmmss")).txt"

# Add WMSvc Port Firewall Allow Rule
New-NetFirewallRule -DisplayName "Allow Web Management Service In" -Direction Inbound -LocalPort 8172 -Protocol TCP -Action Allow