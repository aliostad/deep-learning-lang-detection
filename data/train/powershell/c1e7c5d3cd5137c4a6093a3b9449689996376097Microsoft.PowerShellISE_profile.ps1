#Load the default profile
. "$env:UserProfile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

#Write-Host "`nAdding the ISE Specific stuff"
# Load the ISE Module
#Import-Module ISEPack -EA SilentlyContinue -EV +script:AutoRunErrors
#if($?) {  
#    Write-Host "`t... Added ISE Pack " -fore Cyan
#} else {
#    Write-Host "`t... Errored on ISE Pack " -fore Red
#}

# Set the Console stuff if there is any.

#------------------- Functions ---------------

Function Set-Profile { 
    psedit $profile 
} #end function set-profile 

# Fix for ISE not running shell commands
function vimise { 
    start-process vim $args
}

