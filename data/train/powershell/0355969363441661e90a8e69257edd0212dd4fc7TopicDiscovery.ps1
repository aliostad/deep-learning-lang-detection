param($namespaceName, $password, $assemblyLocation)

$api = New-Object -comObject 'MOM.ScriptAPI'

$api.LogScriptEvent("TopicDiscovery.ps1",200,4,"Staring topic discovery for azure service bus namespace ${namespaceName}")

[Void][System.Reflection.Assembly]::LoadWithPartialName("System")
[Void][System.Reflection.Assembly]::LoadFile($assemblyLocation)


$conn = "Endpoint=sb://" + $namespaceName + "/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=" + $password						
$bag = $api.CreatePropertyBag()

$namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($conn)

$topics = $namespaceManager.GetTopics()

foreach($s in $topics) {

	$api.LogScriptEvent("TopicDiscovery.ps1",201,4,"Discovered topic $($s.Path) in namespace ${namespaceName}")

	$bag = $api.CreatePropertyBag()
	$bag.AddValue("TopicName", $s.Path)					
	$bag.AddValue("MaxSizeInMegaBytes", $s.MaxSizeInMegabytes)		
	$bag
}	
$success = $true	

if($success){
	$api.LogScriptEvent("TopicDiscovery.ps1",202,4,"Completed topic discovery for azure service bus namespace ${namespaceName}")
}

if (($Error.Count -gt 0) -and ($success -eq $false)) { 	
	$api.LogScriptEvent("TopicDiscovery.ps1",205,1,"The following Errors occured while trying to discover the Windows Azure Service Bus topics on Namespace ${namespaceName}: " + $Error[0]) 
}