param(
	$subscriptionId,
	$name,
	$dataCenter,
	$loginHint,
	$restLibDir = (Resolve-Path "..\lib").Path,
	$apiVersion = "2014-04-01"
)
$ErrorActionPreference = "stop"

. "$libDir\management_rest_client.ps1" $libDir
. "$restLibDir\resource_manager_rest_client.ps1" $restLibDir

[Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions") | Out-Null

$managementRestClient = new_management_rest_client_with_adal $loginHint
$subscriptions = $managementRestClient.Request(@{ Verb = "GET"; Url = "https://management.core.windows.net/Subscriptions"; OnResponse = $parse_xml;})
$subscriptionAadTenantId = ($subscriptions.Subscriptions.Subscription | ? { $_.SubscriptionId -eq $subscriptionId }).AADTenantId
if($null -eq $subscriptionAadTenantId) {
	throw "Error: Unable to find aad tenant id for subscription: $($subscriptionId)"
}

$script:restClient = new_resource_manager_rest_client $subscriptionId $subscriptionAadTenantId $loginHint
$script:serializer = New-Object Web.Script.Serialization.JavaScriptSerializer
$script:apiVersion = $apiVersion

function create_resource_group { param($name, $dataCenter)
	$options = @{
		location = $dataCenter;
	}

	$contentJson = $script:serializer.Serialize($options)

	$restClient.Request(@{
		Verb = "PUT";
		Resource = "resourcegroups/$resourceGroup`?api-version=$script:apiVersion";
		OnResponse = $write_host;
		Content = $contentJson;
		ContentType = "application/json";
	})
}

function create_server_farm { param($name, $resourceGroup, $dataCenter)
	$options = @{
		name = $name;
		location = $dataCenter;
		properties = @{
			sku = "Standard";
			workerSize = "1";
			numberOfWorkers = 1;
		}
	}

	$contentJson = $script:serializer.Serialize($options)

	$restClient.Request(@{
		Verb = "PUT";
		Resource = "resourcegroups/$resourceGroup/providers/Microsoft.Web/serverFarms/$name`?api-version=$script:apiVersion";
		OnResponse = $write_host;
		Content = $contentJson;
		ContentType = "application/json";
	})
}

function create_website { param($name, $serverFarm, $resourcGroup, $dataCenter)
	$options = @{
		location = $dataCenter;
		properties = @{
			computeMode = $null;
			name = $name;
			sku = "Standard";
			serverFarm = $serverFarm;
		};
		tags = @{}
	}

	$contentJson = $script:serializer.Serialize($options)

	$restClient.Request(@{
		Verb = "PUT";
		Resource = "resourcegroups/$resourceGroup/providers/Microsoft.Web/sites/$name`?api-version=$script:apiVersion";
		OnResponse = $write_host;
		Content = $contentJson;
		ContentType = "application/json";
	})
}

function delete_resource_group { param($name)
	$restClient.Request(@{
		Verb = "DELETE";
		Resource = "resourcegroups/$resourceGroup`?api-version=$script:apiVersion";
		OnResponse = $write_host;
	})
}

$shortDataCenter = $dataCenter.ToLower().Replace(" ", "")
$resourceGroup = $name

create_resource_group $name $dataCenter
create_server_farm $name $resourceGroup $dataCenter
create_website $name $name $resourceGroup $dataCenter
delete_resource_group $name $dataCenter
