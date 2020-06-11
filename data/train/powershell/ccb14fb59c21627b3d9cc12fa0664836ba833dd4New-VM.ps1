Import-Module "$HOME\GitHub\test-repo\WindowsPowerShell\PSMs\VirtualBox.psm1"
#$vbox = New-Object -ComObject "VirtualBox.VirtualBox"

$iso = "C:\Apps\ISO\ubuntu-16.04-server-amd64.iso"
$vmname = "$((Get-Item $iso).BaseName)-test"
$ostype = "Ubuntu_64"
$memorysize = 2048
$vramsize = 12
$hd_filename = "$(Get-VmFolder)\$vmname\$vmname.vdi"
$hd_size = 65536

# clean up
VBoxManage unregistervm $vmname --delete
VBoxManage closemedium $hd_filename --delete

$vm = New-Vm $vmname $ostype
$vm.MemorySize = $memorysize
$vm.VRAMSize = $vramsize
$vm.RTCUseUTC = 1 # on
Register-Vm $vm

VBoxManage modifyvm $vmname --pae off
VBoxManage modifyvm $vmname --audio dsound --audiocodec ad1980
VBoxManage modifyvm $vmname --usb on
VBoxManage modifyvm $vmname --mouse usbtablet
VBoxManage modifyvm $vmname --nic2 hostonly --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter"

$ide_name = "IDE"
VBoxManage storagectl $vmname --name $ide_name --add ide
VBoxManage storagectl $vmname --name $ide_name --controller PIIX4 --bootable on
VBoxManage storageattach $vmname --storagectl $ide_name --port 1 --device 0 --type dvddrive --medium $iso

$sata_name = "SATA"
VBoxManage storagectl $vmname --name $sata_name --add sata
VBoxManage storagectl $vmname --name $sata_name --controller IntelAhci --portcount 1 --bootable on
VBoxManage createhd --filename $hd_filename --size $hd_size --format VDI --variant Standard
VBoxManage storageattach $vmname --storagectl $sata_name --port 0 --device 0 --type hdd --medium $hd_filename
