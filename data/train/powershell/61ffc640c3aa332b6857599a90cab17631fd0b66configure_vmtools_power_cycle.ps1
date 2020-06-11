#
# tools in power cycle
#
#
# PRE:  Connect-viserver

#
# Configures vm advanced settings
# Verify in web ui
#                vm > Manage > Settings > Vm options > vmware tools > Tools upgrades
#
Function configure_vmtools_power_cycle ( $vm, [bool] $force )
{
    # Older versions:       
    # $is_windows = ($vm.Guest.State -eq "PoweredOn") -and  ($vm.Guest.OSFullName -Match "Windows")
     $is_windows = ($vm.Guest.State -eq "Running") -and  ($vm.Guest.OSFullName -Match "Windows")
   
    #  Comment this line if you want to upgrade non running windows.
    if ( $is_windows -or $force)        
       {
    
        write-host "Configure vmtools check and upgrade in every powercycle: " $vm.Name $vm.Guest.OSFullName

        # This line creates the object that encapsulates the settings for reconfiguring the VM
        $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        # This line creates the object we will be modifying
        $vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
        # This line sets the Tools upgrades policy checkbox
        $vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
        # This line commits the change to each virtual machine
        # Get-View -ViewType VirtualMachine | %{    $_.ReconfigVM($vmConfigSpec)}
    
        # Reconfigure vm
        $vm | Get-View | %{ $_.ReconfigVM($vmConfigSpec)}
        
        
   }
 }
 
 # Forced Apply 
 # configure_vmtools_power_cycle ( get-vm -name 'my_vm') $true
 
 
 #
 # Due to safety reasons, when applying to folders, always check its a windows machines and it is powered on.
 #
 foreach ($vm in get-vm -Location 'Datacenter' )
 {
    configure_vmtools_power_cycle $vm $true
 }
 
 
 
