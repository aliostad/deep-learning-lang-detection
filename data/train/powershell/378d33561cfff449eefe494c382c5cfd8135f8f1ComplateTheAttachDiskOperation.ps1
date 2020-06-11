#http://www.thomasmaurer.ch/2012/04/replace-diskpart-with-windows-powershell-basic-storage-cmdlets/
#http://blogs.msdn.com/b/san/archive/2012/07/03/managing-storage-with-windows-powershell-on-windows-server-2012.aspx
#https://www.windowsazure.com/en-us/manage/windows/how-to-guides/attach-a-disk/

#This will list all the lists
#The ones wit the name of Microsoft Virtual Disk (FriendlyName) are Data Disks
Get-Disk

#Find the DiskNumber and Initialize it
Initialize-Disk 2

#List the partitions for the disk
Get-Partition -DiskNumber 2

#Create a new Partition
New-Partition -DiskNumber 2 -UseMaximumSize

#Get the partitions again
Get-Partition -DiskNumber 2

#Format a new volume
Get-Partition -DiskNumber 2 -PartitionNumber 2 | Format-Volume -FileSystem NTFS

#Assign a Drive Latter
Set-Partition -DiskNumber 2 -PartitionNumber 2 -NewDriveLetter F