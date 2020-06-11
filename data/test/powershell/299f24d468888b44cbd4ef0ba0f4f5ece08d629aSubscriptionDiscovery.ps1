param($namespaceName, $hostName, $assemblyLocation, $topicName)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("SubscriptionDiscovery.ps1",100,4,"Staring subscription discovery for topic ${topicName} on namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $hostName + "/" +$namespaceName + ";StsEndpoint=https://" + $hostName +":9355/" + $namespaceName +";RuntimePort=9354;ManagementPort=9355"								
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$sub = $namespaceManager.GetSubscriptions($topicName)

foreach($s in $sub) {

	$api.LogScriptEvent("SubscriptionDiscovery.ps1",100,4,"Discovered subscription $($s.Name) in namespace ${namespaceName} and topic ${topicName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("SubscriptionName", $s.Name)						
	$bag

	$success = $true
}		

if($success){
	$api.LogScriptEvent("SubscriptionDiscovery.ps1",101,4,"Completed subscription discovery for topic ${topicName} on namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) 
{ 	
	$api.LogScriptEvent("SubscriptionDiscovery.ps1",200,1,"The following Errors occured while trying to discover the Service Bus for Windows Server subscriptions on Namespace ${namespaceName} and Topic ${topicName}: " + $Error[0]) 
}