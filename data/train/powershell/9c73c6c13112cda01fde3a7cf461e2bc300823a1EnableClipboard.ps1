#Clipboard Copy and Paste does not work in vSphere Client 4.1 and later
#http://kb.vmware.com/kb/1026437

$copy = New-Object VMware.Vim.optionvalue
$copy.Key="isolation.tools.copy.disable"
$copy.Value="FALSE"

$paste = New-Object VMware.Vim.optionvalue
$paste.Key="isolation.tools.paste.disable"
$paste.Value="FALSE"

#Create a Machine Config Spec using the three option values specified above
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$vmConfigSpec.extraconfig += $copy
$vmConfigSpec.extraconfig += $paste

#Get a VM View collection of all the VMs that need to have these options
import-csv c:\vmware\LinkedClone.csv | foreach{ 
$SourceName = $_.CloneName
$vms = get-view -viewtype virtualmachine |where {$_.name -eq $SourceName}
 foreach($vm in $vms){
 $vm.ReconfigVM($vmConfigSpec)
 }
}


