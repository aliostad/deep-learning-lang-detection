param($namespaceName, $password, $assemblyLocation, $topicName)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("SubscriptionDiscovery.ps1",300,4,"Staring subscription discovery for topic ${topicName} on namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $namespaceName + "/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=" + $password						
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$sub = $namespaceManager.GetSubscriptions($topicName)

foreach($s in $sub) {

	$api.LogScriptEvent("SubscriptionDiscovery.ps1",301,4,"Discovered subscription $($s.Name) in namespace ${namespaceName} and topic ${topicName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("SubscriptionName", $s.Name)						
	$bag
}		
$success = $true

if($success){
	$api.LogScriptEvent("SubscriptionDiscovery.ps1",302,4,"Completed subscription discovery for topic ${topicName} on namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) 
{ 	
	$api.LogScriptEvent("SubscriptionDiscovery.ps1",305,1,"The following Errors occured while trying to discover the Windows Azure Service Bus subscriptions on Namespace ${namespaceName} and Topic ${topicName}: " + $Error[0]) 
}