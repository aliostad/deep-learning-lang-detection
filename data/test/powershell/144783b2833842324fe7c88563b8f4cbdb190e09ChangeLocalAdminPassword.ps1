##################################################
# ChangeLocalAdminPassword.ps1
# Used to change the local admin passwords for machine
# acounts in Active Directory.
# 
# Created: 11/2/2006
# Author: Tyson Kopczynski
##################################################
param([string] $OUDN)

##################################################
# Functions
##################################################
#-------------------------------------------------
# Set-ChoiceMessage
#-------------------------------------------------
# Usage:        Used to set yes and no choice options.
# $No:          The no message.
# $Yes:         The yes message.
function Set-ChoiceMessage{
param ($No, $Yes)
$N = ([System.Management.Automation.Host.ChoiceDescription]”&No”)
$N.HelpMessage = $No 
$Y = ([System.Management.Automation.Host.ChoiceDescription]”&Yes”)
$Y.HelpMessage = $Yes
Return ($Y,$N) 
}
#-------------------------------------------------
# New-PromptYesNo
#-------------------------------------------------
# Usage:        Used to display a choice prompt.
# $Caption:     The prompt caption.  
# $Message:     The prompt message.
# $Choices:     The object catagory.  
function New-PromptYesNo{
param ($Caption, $Message, 
[System.Management.Automation.Host.ChoiceDescription[]]$Choices)
$Host.UI.PromptForChoice($Caption, $Message, $Choices, 0)
}
