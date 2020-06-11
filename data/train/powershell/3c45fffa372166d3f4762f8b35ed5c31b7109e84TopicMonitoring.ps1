param($namespaceName, $hostName, $assemblyLocation, $topicName)

$api = New-Object -comObject 'MOM.ScriptAPI'

#$api.LogScriptEvent("TopicMonitoring.ps1",100,4,"Staring topic monitoring for topic ${topicName} on namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)

$conn = "Endpoint=sb://" + $hostName + "/" +$namespaceName + ";StsEndpoint=https://" + $hostName +":9355/" + $namespaceName +";RuntimePort=9354;ManagementPort=9355"						
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)
$topic = $namespaceManager.GetTopic($topicName)

$bag.AddValue("Status", $topic.Status.ToString())
$bag.AddValue("AvailabilityStatus", $topic.AvailabilityStatus.ToString())
$bag.AddValue("IsAnonymousAccessible", $topic.IsAnonymousAccessible)
$bag.AddValue("SizeInBytes", $topic.SizeInBytes)
$bag.AddValue("SubscriptionCount", $topic.SubscriptionCount)

$success = $true						

$bag

if($success){
	#$api.LogScriptEvent("TopicMonitoring.ps1",301,4,"Completed topic monitoring for topic ${topicName} on namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) 
{ 	
	$api.LogScriptEvent("TopicMonitoring.ps1",315,1,"The following Errors occured while trying to monitor the topic ${topicName} on Namespace ${namespaceName}:" + $Error[0]) 
}