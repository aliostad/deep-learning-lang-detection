################################################################################################################

#
# NAME
#     Copy-Data
#
# SYNOPSIS
#     Copy Data between Folders including a Progressbar
#
# SYNTAX
#     Copy-Data [Source <PathToSource>] [Destination <PathToDestination>] [-Confirm] [-Recurse]
#     
#
# DETAILED DESCRIPTION
#	The Copy-Data cmdlet copies an item from one location to another in a namespace. Copy-Data does not	

#	delete 	the items being copied.
#
# PARAMETERS
#     -Confirm <SwitchParameter>
#         Prompts you for confirmation before executing the command.
#
#         Required?                    false
#         Position?                    named
#         Default value                
#         Accept pipeline input?       false
#         Accept wildcard characters?  false
#
#     -Recurse <SwitchParameter>
#         Specifies a recursive copy.
#
#         Required?                    false
#         Position?                    named
#         Default value                
#         Accept pipeline input?       false
#         Accept wildcard characters?  false
#
#
# INPUT TYPE
#     
#
# RETURN TYPE
#     Shows a progressbar where you can see the progress
#
# NOTES
#
#	-------------------------- EXAMPLE 1 --------------------------
#   
#   C:\PS>copy-Data C:\Wabash\Logfiles\mar1604.log.txt C:\Presentation
#
#
#
#	-------------------------- EXAMPLE 2 --------------------------
#   
#   C:\PS>copy-Data C:\Wabash\Logfiles\*.txt C:\Presentation


function copy-data {
	param(
		[string]$file = "",
		[string]$dest = "",
		[switch]$Recurse,
		[switch]$Confirm
	)
		
$copy = cp $file $dest
for ($a=1; $a -lt 100; $a++) {
Write-Progress -Activity “Copying...” -SecondsRemaining $a -Status "% Complete:" -percentComplete $a
}
}


set-Alias cpd copy-data