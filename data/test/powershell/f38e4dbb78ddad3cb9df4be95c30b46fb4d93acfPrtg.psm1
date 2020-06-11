#######################################################################################################################
# File:             Prtg.psm1                                                                               #
# Author:           Thomy Kay                                                                                         #
# Publisher:                                                                                                          #
# Copyright:        © 2013 . All rights reserved.                                                                     #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the PoshConfluence module.                                                               #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name PoshConfluence                                                            #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

# TODO: Define your module here.

$Script:PrtgSessionManager = New-Object ThomyKay.Prtg.PrtgSessionManager

# Common cmdlets
. $psScriptRoot\Enter-Session.ps1
. $psScriptRoot\Get-Session.ps1
. $psScriptRoot\Get-Sensor.ps1
. $psScriptRoot\Get-Group.ps1
. $psScriptRoot\Get-Message.ps1
. $psScriptRoot\Get-Device.ps1

$exportedCmdlets = @(	"Enter-Session", `
						"Get-Session", `
						"Get-Sensor",`
						"Get-Group",`
						"Get-Message",`
						"Get-Device")

Export-ModuleMember -Cmdlet $exportedCmdlets -Function $exportedCmdlets -Variable $PrtgSessionManager



