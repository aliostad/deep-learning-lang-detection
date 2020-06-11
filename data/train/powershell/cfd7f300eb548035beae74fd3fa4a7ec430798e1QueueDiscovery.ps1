param($namespaceName, $password, $assemblyLocation)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("QueueDiscovery1.ps1",100,4,"Starting queue discovery for azure service bus namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $namespaceName + "/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=" + $password						
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$queues = $namespaceManager.GetQueues()

foreach($s in $queues) {

	$api.LogScriptEvent("QueueDiscovery1.ps1",101,4,"Discovered queue $($s.Path) in namespace ${namespaceName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("QueueName", $s.Path)					
	$bag.AddValue("MaxSizeInMegaBytes", $s.MaxSizeInMegabytes)		
	$bag

	$success = $true
}		

if($success){
	$api.LogScriptEvent("QueueDiscovery1.ps1",102,4,"Completed queue discovery for azure service bus namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) { 	
	$api.LogScriptEvent("QueueDiscovery1.ps1",105,1,"The following Errors occured while trying to discover the Windows Azure Service Bus namespace on Namespace ${namespaceName}: " + $Error[0]) 
}