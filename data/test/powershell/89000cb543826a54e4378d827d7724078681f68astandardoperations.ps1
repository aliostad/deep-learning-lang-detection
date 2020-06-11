# parameterblock (callblock)
param(
$vmName,	#name of the vm
$call		#operation to be executed
)

$location = Get-Content "./path.txt" | select -Index 0

if($call -eq "start"){
	Start-VM $vmName
}

elseif($call -eq "stop"){
	Stop-VM $vmName -Force
}
elseif($call -eq "restart"){
	Restart-VM $vmName
}

elseif($call -eq "suspend"){
	Suspend-VM $vmName
}
elseif($call -eq "resume"){
	Resume-VM $vmName
}
elseif($call -eq "save"){
	Save-VM $vmName
}
elseif($call -eq "delete"){
	Stop-VM -Name $vmName -Force
	Remove-VM -Name $vmName -Force
	Remove-Item $location\$vmName -Force -Recurse
}
