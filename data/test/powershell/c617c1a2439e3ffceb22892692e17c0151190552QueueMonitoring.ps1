param($namespaceName, $password, $assemblyLocation, $queueName)

$api = New-Object -comObject 'MOM.ScriptAPI'

#$api.LogScriptEvent("QueueMonitoring.ps1",110,4,"Staring queue monitoring for queue ${queueName} on namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $namespaceName + "/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=" + $password						
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)

$queue = $namespaceManager.GetQueue($queueName)

$bag.AddValue("Status", $queue.Status.ToString())
$bag.AddValue("AvailabilityStatus", $queue.AvailabilityStatus.ToString())
$bag.AddValue("IsAnonymousAccessible", $queue.IsAnonymousAccessible)
$bag.AddValue("MessageCount", $queue.MessageCount)
$bag.AddValue("SizeInBytes", $queue.SizeInBytes)


$client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($conn, $queueName)
$oldestDate = [System.DateTime]::UtcNow

$peekedMessages = $client.PeekBatch(1000)

foreach($message in $peekedMessages){
	$messDate = $message.EnqueuedTimeUtc

	if($messDate -lt $oldestDate){        
		$oldestDate = $messDate;
	}
}
$oldCount = [System.Convert]::ToInt32(([System.DateTime]::UtcNow - $oldestDate).TotalMinutes)

$bag.AddValue("OldMessageMinutes", $oldCount)

$deadLetterCount = 0
$dlClient = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($conn, [Microsoft.ServiceBus.Messaging.QueueClient]::FormatDeadLetterPath($queueName));
$deadLetterCount = $dlClient.PeekBatch(1000).Count

$bag.AddValue("DeadLetterCount", $deadLetterCount)

$bag

$success = $true						

if($success){
	#$api.LogScriptEvent("QueueMonitoring.ps1",111,4,"Completed queue monitoring for queue ${queueName} on namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) 
{ 	
	$api.LogScriptEvent("QueueMonitoring.ps1",115,1,"The following Errors occured while running on Namespace ${namespaceName} and Queue ${queueName}: " + $Error[0]) 
}