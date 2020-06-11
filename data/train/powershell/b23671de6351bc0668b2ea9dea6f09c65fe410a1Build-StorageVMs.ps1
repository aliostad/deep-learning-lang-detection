

#Script to create a handful of identical storage-oriented VirtualBox VMS automatically with multiple hard-drives attached for use in a cluster scenario.
#IE Ceph, Replication Nodes, Shared Storage ETC

#Just call the script and pass in the parameters.

function Build-VMs ()
{
    [CMDletBinding()]
    Param(
       
      [Parameter(Mandatory=$True,Position=1)]
      [String]$ostype,

      [Parameter(Mandatory=$True)]
      [int]$hosts,

      [Parameter(Mandatory=$True)]
      [int]$sasdrives
    )

    if ($hosts -lt 1)
    {
       echo "Please enter a number of hosts greater than 0"
       exit
    }
    
    $counter = 0
    $sascounter = 0
    DO{
    
    
    VBoxManage createvm --name "StorageHost_$counter"  --register
    VBoxManage modifyvm "StorageHost_$counter" --ostype $ostype

    
    VBoxManage modifyvm "StorageHost_$counter" --memory 4096
    VBoxManage modifyvm "StorageHost_$counter" --cpus 2
    VBoxManage modifyvm "StorageHost_$counter" --ioapic on

    VBoxManage storagectl "StorageHost_$counter" --name IDE --add ide --controller PIIX4 --bootable on
    VBoxManage storagectl "StorageHost_$counter" --name SATA --add sata --controller IntelAhci --bootable on
    VBoxManage storagectl "StorageHost_$counter" --name SAS --add sas --controller LSILogicSAS
    
    VBoxManage createhd --filename "Boot_StorageHost_$counter.vdi" --size 32768

    VBoxManage storageattach "StorageHost_$counter" --storagectl IDE --port 0 --device 0 --type dvddrive --medium emptydrive
    VBoxManage storageattach "StorageHost_$counter" --storagectl SATA --port 0 --device 0 --type hdd --medium Boot_StorageHost_$counter.vdi

      DO{
        
      VBoxManage createhd --filename "SAS$sascounter StorageHost_$counter.vdi"  --size 131072
      VBoxManage storageattach "StorageHost_$counter" --storagectl SAS --port $sascounter --device 0 --type hdd --medium "SAS$sascounter StorageHost_$counter.vdi"

      $sascounter++

      } While ($sascounter -le ($sasdrives-1))
    

    VBoxManage modifyvm "StorageHost_$counter" --nic1 nat --nictype1 82540EM --cableconnected1 on
    VBoxManage modifyvm "StorageHost_$counter" --nic2 bridged --nictype1 82540EM --cableconnected1 on

    
    $counter++
    
    } While ($counter -le ($hosts-1))
       

}

Build-VMs