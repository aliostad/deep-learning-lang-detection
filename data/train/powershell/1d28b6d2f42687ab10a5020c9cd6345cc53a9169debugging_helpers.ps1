
function i {
    Import-Module ".\BuildScripts.psm1" -Force
}

function c {
    # remember to remove the ps session with Remove-PSSession -Id 3
    $credential = Get-PSCredential "Administrator" "P@$$\/\/0r|)" 
    #$session = New-PSSession -ComputerName "54.79.69.203" -credential $credential
    $session = New-PSSession -ComputerName "60.70.80.90" -credential $credential
    $session
}

function Get-PSCredential($username, $password){
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($username, $securePassword)   
}


#---------------------

function Save-AllISEFiles

{
<#
.SYNOPSIS
    Saves all ISE Files except for untitled files. If You have       multiple PowerShellTabs, saves files in all tabs.
#>
    foreach($tab in $psISE.PowerShellTabs)
    {
        foreach($file in $tab.Files)
        {
            if(!$file.IsUntitled)
            {
                $file.Save()
            }
        }
    }
}

function setup { 
# This line will add a new option in the Add-ons menu to save all ISE files with the Ctrl+Shift+S shortcut.
# If you try to run it a second time it will complain that Ctrl+Shift+S is already in use
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Save All",{Save-AllISEFiles},"Ctrl+Shift+S")

# Install File Explorer from :
# http://gallery.technet.microsoft.com/Powershell-ISE-Explorer-bfc92307
}