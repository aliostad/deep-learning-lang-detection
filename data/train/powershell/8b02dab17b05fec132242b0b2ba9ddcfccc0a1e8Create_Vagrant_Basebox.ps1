#Create the basebox with vagrant 
[CmdletBinding()]
Param(
	[string]$Basebox_Name
)
if (-not $Basebox_Name)
{
	Write-Output "Please Specify a Basebox Name"
	exit
}

#Initialize the Virtiualbox COM object
$vBoxAPI = New-Object -ComObject VirtualBox.VirtualBox
$vBox = $vBoxAPI.FindMachine($Basebox_Name)
$VM_Name = $vBox.Name
$vBox.
