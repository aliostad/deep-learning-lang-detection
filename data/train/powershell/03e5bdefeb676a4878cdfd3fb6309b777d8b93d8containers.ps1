# Use the following command to download the configuration script. 
# The script can also be manually downloaded from this location - https://aka.ms/newcontainerhost

wget -uri https://aka.ms/newcontainerhost -OutFile New-ContainerHost.ps1


# Run the following command to create and configure the container host 
# where $containerhost will be the virtual machine name 
# and $password will be the password assigned to the Administrator account.

$containerhost = "TP3ContainerHost"
$password = "Passw0rd!"

.\New-ContainerHost.ps1 –VmName $containerhost -Password $password


# When the script begins you will be asked to read and accept licensing terms.

# The script will then begin to download and configure the Windows Server Container components. 
# This process may take quite some time due to the large download. 
# When finished your Virtual Machine will be configured and ready for you to create and manage 
# Windows Server Containers and Windows Server Container Images with both PowerShell and Docker. 

# You may receive the following message during the Window Server Container host deployment process. 
# This VM is not connected to the network. To connect it, run the following:

Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>


# If you do, check the properties of the virtual machine and connect the virtual machine to a 
# virtual switch. You can also run the following PowerShell command where <switchname> 
# is the name of the Hyper-V virtual switch that you would like to connect to the virtual machine.

Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>
