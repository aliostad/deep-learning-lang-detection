#  This script can be used to load Hyper-V VMs in bulk from an XML source file
#  http://www.sharepointlonghorn.com/
#  v1.37 02/06/2015
#  Jason Himmelstein

# setup the parameter file
$parameterfile = "C:\Users\jhimmelstein\Documents\GitHub\powershell\server setup\vmconfig-LAB.xml"
[xml]$configdata = Get-Content $parameterfile -ErrorAction Stop

# Load the xml objects into memory
$nodes = $configdata.Servers.VMs.ChildNodes | Select-Object MemoryStartupBytes,generation,bootdevice,vhdpath,switchname,path,servername,processors,dynamicmemory

#Create the new VMs
foreach ($node in $nodes) 
 {
New-VM –Name $node.servername –MemoryStartupBytes $node.memstart -Generation $node.gen -BootDevice $node.bootd -VHDPath $node.vhdpath -SwitchName $node.switchname -Path $node.fpath
Set-VMProcessor $node.servername -Count $node.corecount
Set-VMMemory $node.servername -DynamicMemoryEnabled $node.dynmem
}