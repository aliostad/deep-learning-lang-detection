param($namespaceName, $hostName, $assemblyLocation)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("QueueDiscovery1.ps1",100,4,"Starting queue discovery for azure service bus namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $hostName + "/" +$namespaceName + ";StsEndpoint=https://" + $hostName +":9355/" + $namespaceName +";RuntimePort=9354;ManagementPort=9355"								
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$queues = $namespaceManager.GetQueues()

foreach($s in $queues) {

	$api.LogScriptEvent("QueueDiscovery1.ps1",100,4,"Discovered queue $($s.Path) in namespace ${namespaceName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("QueueName", $s.Path)						
	$bag

	$success = $true
}		

if($success){
	$api.LogScriptEvent("QueueDiscovery1.ps1",101,4,"Completed queue discovery for azure service bus namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) { 	
	$api.LogScriptEvent("QueueDiscovery1.ps1",200,1,"The following Errors occured while trying to discover the Service Bus for Windows Server namespace on Namespace ${namespaceName}: " + $Error[0]) 
}