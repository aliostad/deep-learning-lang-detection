param($namespaceName, $hostName, $assemblyLocation)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("TopicDiscovery.ps1",100,4,"Staring topic discovery for azure service bus namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $hostName + "/" +$namespaceName + ";StsEndpoint=https://" + $hostName +":9355/" + $namespaceName +";RuntimePort=9354;ManagementPort=9355"
$bag = $api.CreatePropertyBag()
$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)

$topics = $namespaceManager.GetTopics()
$api.LogScriptEvent("TopicDiscovery.ps1",105,4,"got topics ${namespaceName}")

foreach($s in $topics) {

	$api.LogScriptEvent("TopicDiscovery.ps1",106,4,"Discovered topic $($s.Path) in namespace ${namespaceName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("TopicName", $s.Path)						
	$bag

	$success = $true
}		

if($success){
	$api.LogScriptEvent("TopicDiscovery.ps1",101,4,"Completed topic discovery for azure service bus namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) { 	
	$api.LogScriptEvent("TopicDiscovery.ps1",200,1,"The following Errors occured while trying to discover the Service Bus for Windows Server topics on Namespace ${namespaceName}: " + $Error[0]) 
}