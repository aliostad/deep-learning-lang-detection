[CmdletBinding()]
Param(
	[Parameter(Position=1)]
	[string]$groupname,
	[string]$resourceGroupName,
	[string]$tweetPublishServiceName,
	[string]$tweetHandlerServiceName,
	[string]$storageAccountName,
	[string]$deploymentStorageName,
	[string]$searchName,
	[string]$templateFile = ".\tweet-publish-subscribe.json"

)

if (!$groupname){
	$groupname = Read-Host "Enter group number or short group name (max 5 characters!)" 
	$grouptag = $groupname	
}
	 
if($groupname.Length -lt 3){
	$groupname = "GRGroup" + $groupname
}
     
$resourceGroupName = $groupname + "Resources"
$tweetPublishServiceName = $groupname + "TweetPublisher"
$tweetHandlerServiceName = $groupname + "TweetHandler"
$searchName = $groupname.ToLower() + "search"
$storageAccountName = $groupname.ToLower() + "storage"
$deploymentStorageName = $groupname.ToLower() + "deployments"
$hostingPlanName = $groupname + "HostingPlan"
$websiteName = $groupname + "Web"

$handlerProjPath = "..\TweetHandlerService\TweetHandlerService.ccproj"
$publisherProjPath = "..\TweetPublishService\TweetPublishService.ccproj"
$currentDir = (Get-Item -Path ".\" -Verbose).FullName
$handlerOutpath = "$currentDir\HandlerOut\"	
$publisherOutpath = "$currentDir\PublisherOut\"	
	
try{	
	Write-Host "Creating new Azure resource group - $resourceGroupName `n Using template $templateFile"
	. .\Create-GRResourceGroup -groupname $groupname
}Catch{
	$errorMessage = $_.Exception.Message
	$errorMessage
}																										   

try{
	Write-Host "Packaging handler project"						
	. .\Package-CloudServiceProject -csprojpath $handlerProjPath -out $handlerOutpath
					
}Catch{
	$errorMessage = $_.Exception.Message
	$errorMessage
}

try{
	Write-Host "Packaging publish project"
	. .\Package-CloudServiceProject -csprojpath $publisherProjPath -out $publisherOutpath	
					
}Catch{
	$errorMessage = $_.Exception.Message
	$errorMessage
}

$publishDirHandler = "$currentDir\HandlerOut\app.publish"
$publishDirPublisher = "$currentDir\PublisherOut\app.publish"
	
try{
	. .\Set-ProjectCloudConfigurations.ps1 -groupname $grouptag -publishDir $publishDirHandler -workerName "TweetHandler" -storageAccountName $storageAccountName

	try{
		. .\Set-ProjectCloudConfigurations.ps1 -groupname $grouptag -publishDir $publishDirHandler -workerName "SearchIndexWorker" -storageAccountName $storageAccountName -searchName $searchName -s
	}Catch{
		$errorMessage = $_.Exception.Message
		"No SearchIndexer role found:   $errorMessage"	
	}
	. .\Set-ProjectCloudConfigurations.ps1 -groupname $grouptag -publishDir $publishDirPublisher -workerName "TweetrPublisher" -storageAccountName $storageAccountName
}Catch{
	$errorMessage = $_.Exception.Message
	$errorMessage
}

$subscription = (Get-AzureSubscription -Current).SubscriptionId
$tweetPublisherConfig = "$publishDirPublisher\ServiceConfiguration.Cloud.cscfg"
$tweetPublisherPackage = "$publishDirPublisher\TweetPublishService.cspkg"

$tweetHandlerConfig = "$publishDirHandler\ServiceConfiguration.Cloud.cscfg"
$tweetHandlerPackage = "$publishDirHandler\TweetHandlerService.cspkg"
	
try{
	. .\Publish-CloudServiceFromPackage.ps1 -storageaccount $storageAccountName -subscription $subscription -cloudServiceName $tweetPublishServiceName `
											-config $tweetPublisherConfig -package $tweetPublisherPackage -groupname $grouptag
											
	. .\Publish-CloudServiceFromPackage.ps1 -storageaccount $storageAccountName -subscription $subscription -cloudServiceName $tweetHandlerServiceName `
											-config $tweetHandlerConfig -package $tweetHandlerPackage -groupname $grouptag											
}Catch{
	$errorMessage = $_.Exception.Message
	$errorMessage
}


	  