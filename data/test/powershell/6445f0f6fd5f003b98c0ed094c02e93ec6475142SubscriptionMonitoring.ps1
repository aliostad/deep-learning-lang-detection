param($namespaceName, $hostName, $assemblyLocation, $topicName, $subscriptionName)

$api = New-Object -comObject 'MOM.ScriptAPI'

#$api.LogScriptEvent("SubscriptionMonitoring.ps1",100,4,"Staring subscription monitoring for subscription ${subscriptionName} on topic $topicName and namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $hostName + "/" +$namespaceName + ";StsEndpoint=https://" + $hostName +":9355/" + $namespaceName +";RuntimePort=9354;ManagementPort=9355"								
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$sub = $namespaceManager.GetSubscription($topicName, $subscriptionName)

$bag.AddValue("Status", $sub.Status.ToString())
$bag.AddValue("AvailabilityStatus", $sub.AvailabilityStatus.ToString())
$bag.AddValue("MessageCount", $sub.MessageCount)

$client = [Microsoft.ServiceBus.Messaging.SubscriptionClient]::CreateFromConnectionString($conn, $topicName, $subscriptionName)
	
$oldestDate = [System.DateTime]::UtcNow

$peekedMessages = $client.PeekBatch(1000)

foreach($message in $peekedMessages){
	$messDate = $message.EnqueuedTimeUtc

	if($messDate -lt $oldestDate){        
		$oldestDate = $messDate;
	}
}
$oldCount = ([System.DateTime]::UtcNow - $oldestDate)::Minutes

$bag.AddValue("OldMessageMinutes", $oldCount)


$dlClient = [Microsoft.ServiceBus.Messaging.SubscriptionClient]::CreateFromConnectionString($conn, [Microsoft.ServiceBus.Messaging.SubscriptionClient]::FormatDeadLetterPath($topicName, $subscriptionName));
[int]$deadLetterCount = $dlClient.PeekBatch(1000).Count
$bag.AddValue("DeadLetterCount", $deadLetterCount)


$success = $true						

$bag

if($success){
	#$api.LogScriptEvent("SubscriptionMonitoring.ps1",201,4,"Completed subscription monitoring for subscription ${subscriptionName} on topic $topicName and namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) 
{ 	
	$api.LogScriptEvent("SubscriptionMonitoring.ps1",215,1,"The following Errors occured while running subscription monitoring for subscription ${subscriptionName} on topic $topicName and namespace ${namespaceName}: " + $Error[0]) 
}