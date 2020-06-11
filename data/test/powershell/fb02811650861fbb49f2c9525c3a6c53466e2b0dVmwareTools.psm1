#######################################################################################################################
# File:             VmwareTools.psm1                                                                                #
# Author:           Levon Becker                                                                                      #
# Publisher:        Bonus Bits                                                                                        #
# Copyright:        © 2012 Bonus Bits. All rights reserved.                                                           #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the VmwareTools module.                                                                #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name VmwareTools                                                             #
#######################################################################################################################


[string]$Global:VmwareToolsModulePath = $PSScriptRoot

# LOAD PARENT SCRIPTS
Try {
    Get-ChildItem -Path "$PSScriptRoot\ParentScripts\*.ps1" | Select-Object -ExpandProperty FullName | ForEach {
        # USED FOR EXCEPTION MESSAGE
		$Function = Split-Path $_ -Leaf
		# DOT SOURCE EACH SUBSCRIPT
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)
    Continue
} 

# LOAD SUB SCRIPTS
Try {
    Get-ChildItem -Path "$PSScriptRoot\SubScripts\*.ps1" | Select-Object -ExpandProperty FullName | ForEach {
        # USED FOR EXCEPTION MESSAGE
		$Function = Split-Path $_ -Leaf
		# DOT SOURCE EACH SUBSCRIPT
        . $_
    }
} Catch {
    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)
    Continue
}   

# SHOW HEADER IF NO ARG 
If ( $Args.Length -gt 0 ) {
	$Script:NoHeader = $Args[0]
}

If ($Script:NoHeader -ne $true) {	
	Show-VmwareToolsHeader -SubScripts "$PSScriptRoot\SubScripts"
}

