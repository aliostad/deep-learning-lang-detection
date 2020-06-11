Param($VirtualMachineId)

$ScriptName = 'Community.VMware.Unsealed.Task.AddVirtualMachineToUnmonitoredGroup.ps1'
$api = new-object -comObject 'MOM.ScriptAPI'

Import-Module OperationsManager
New-SCOMManagementGroupConnection 'localhost'

$MGconn = Get-SCOMManagementGroupConnection | Where {$_.IsActive -eq $true}

If(!$MGconn){
	$api.LogScriptEvent($ScriptName,1985,2,"Unable to connect to the local management group")
	exit
}

$Discovery = Get-SCOMDiscovery -Name 'Community.VMware.Unsealed.Discovery.Group.UnmonitoredVirtualMachines'

If ($Discovery){

	IF($Discovery.DataSource.Configuration -match '<Pattern>(?<content>.*)</Pattern>'){
		$NewConfig = $Discovery.DataSource.Configuration -replace '<Pattern>(?<content>.*)</Pattern>', ('<Pattern>'+($Matches['content']).Insert(1,($VirtualMachineId+'|')) + '</Pattern>')
		$Discovery.DataSource.set_Configuration($NewConfig)
		$Discovery.Status = [Microsoft.EnterpriseManagement.Configuration.ManagementPackElementStatus]::PendingUpdate
		$MP = $Discovery.GetManagementPack()
		$MP.AcceptChanges()
	}
	Else {Write-Host 'Failed'}
}
Else {Write-Host 'Failed'}