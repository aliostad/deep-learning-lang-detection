param(
	$aadTenantId,
	$name,
	$loginHint,
	$restLibDir = (Resolve-Path "..\lib").Path,
	$apiVersion = "1.5"
)
$ErrorActionPreference = "stop"

. "$restLibDir\azure_ad_rest_client.ps1" $restLibDir

[Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions") | Out-Null

$script:restClient = new_azure_ad_rest_client $aadTenantId $loginHint
$script:serializer = New-Object Web.Script.Serialization.JavaScriptSerializer
$script:apiVersion = $apiVersion

function create_application { param($name, $audienceUri, $homepage)
	$def = @{
		displayName = $name;
		identifierUris = @(,$audienceUri);
		replyUrls = @(,$homePage);
		homepage = $homePage;
		errorUrl = $homePage;
		logoutUrl = $homePage;
	}

	$defJson = $script:serializer.Serialize($def)

	$restClient.Request(@{
		Verb = "POST";
		Resource = "applications`?api-version=$script:apiVersion";
		OnResponse = $parse_json;
		Content = $defJson;
		ContentType = "application/json";
	})
}

function delete_application { param($appId)
	$restClient.Request(@{
		Verb = "DELETE";
		Resource = "applications/$appId`?api-version=$script:apiVersion";
		OnResponse = $write_host;
	})
}

$app = create_application $name "http://$name" "http://$name"
delete_application $app.objectId
