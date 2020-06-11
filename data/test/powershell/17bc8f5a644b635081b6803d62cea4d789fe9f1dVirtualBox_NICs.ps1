<# Enable all 8 NICs for the VMs in VirtualBox, NIC 5-8 still won't show in the GUI though... #>

$VBOX="c:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$HostAdapter="Realtek PCIe GBE Family Controller"
$NicType="82543GC"

$VMs=&$VBOX -q list vms
$VMSplit=$VMs.Split("") 
$VMName=$VMSplit[0].Replace("`"","")
$NumNic=1

$VMS | ForEach-Object {
    while ($NumNic -le 8) {
        &$VBOX modifyvm $VMName --nic$NumNic bridged --bridgeadapter$NUMNic $HostAdapter --nictype$NumNic $NicType
        ++$NumNic
   }
}