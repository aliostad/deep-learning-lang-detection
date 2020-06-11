function Show-CreateVM {
    Param(
        $vhdPAth = "vhds\vm.vhdx",
        $isoPAth="C:\Users\Adrian\Downloads\ubuntu-14.04-server-amd64.iso"
    )

    $vmSwitch = "external"
    New-VHD $vhdpath -Dynamic -SizeBytes (16 * 1024 * 1024 * 1024)
    $vmname = "testvm1"
    $vm = New-VM $vmname -MemoryStartupBytes 512MB
    $vm | Set-VM -ProcessorCount 2
    $vm.NetworkAdapters | Connect-VMNetworkAdapter -SwitchName $vmSwitch
    $vm | Add-VMHardDiskDrive -ControllerType IDE -Path $vhdpath
    $vm | Add-VMDvdDrive -Path $isopath
}

Show-CreateVM
