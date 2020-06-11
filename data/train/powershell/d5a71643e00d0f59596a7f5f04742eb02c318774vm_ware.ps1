$vm_ware_folder = $PSScriptRoot

write-warning "vm_ware functions are being loaded, but are not usable until their PSSnapins have been loaded.
Clients of this module will need to load these snappins before using this module's functionality.
To make this process as repeatable as possible a function  has been provided, vm_code_to_load_vm_once_per_session_only_outside_of_pratom.
For the most 'correct' usage, see the function's documentation, however, as of 2013.11.19, here is the correct usage:

<# ---------------------------------------------------------------------------- #>
`$code_to_run = vm_code_to_load_vm_once_per_session_only_outside_of_pratom
Invoke-Expression `$code_to_run
<# ---------------------------------------------------------------------------- #>

"

# mask Get-Credential so that it doesn't get us stuck...
# pr_include (code_to_load_a_file "$vm_ware_folder\Get-Credential.ps1")

<#
DONE_TODO : FIX THIS
Add-PSSnapin : An item with the same key has already been added.
At C:\projects\ready_bake\simple_simple\simple_ubuntu_changes_for_stoker.ps1:16 char:1
+ Add-PSSnapin VMware.VimAutomation.Core
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Add-PSSnapin], ArgumentException
    + FullyQualifiedErrorId : System.ArgumentException,Microsoft.PowerShell.Commands.AddPSSnapinCommand
#>


<#
Settings files:

    * File : Host Credentials

    * File : VM Guest Credentials

    * File : VM Guest List ( maps to VM Host )

    * File : VM Host List
#>