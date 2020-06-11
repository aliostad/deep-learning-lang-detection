$action = 
{
    $nic = Get-NetAdapter -InterfaceDescription $event.SourceEventArgs.NewEvent.InstanceName
    
    [System.Windows.Forms.MessageBox]::Show("$($nic.InterfaceDescription)","$($nic.Name)")
}

Register-WmiEvent -Class MSNdis_StatusMediaDisconnect -Namespace root/wmi -SourceIdentifier NIC -Action $action

break 

$action = 
{
    $nic = Get-NetAdapter -InterfaceDescription $event.SourceEventArgs.NewEvent.InstanceName
    
    [System.Windows.Forms.MessageBox]::Show("$($nic.InterfaceDescription)","$($nic.InterfaceIndex)")
}

Register-WmiEvent -Class MSNdis_StatusMediaConnect -Namespace root/wmi -SourceIdentifier NIC -Action $action