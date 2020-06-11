# Setup a bunch of calls to test O365 Management API

# Import ENV vars
. '.\config.ps1'

If(-Not $isS2SEnabled) {

	Write-Host "`n -- NO S2S Enabled -> Human Simulation (check you have the correct authCode in config.ps1)`n" -foregroundcolor "Yellow"

	Write-Host "`n -- Retrieving AccessToken from Azure...`n" -foregroundcolor "Yellow"
	# Perform /token request towards common endpoint
	$jsonToken = & '.\bin\curl.exe' $requestPOST $commonTokenRESTEndpoint $resourceParam $clientIDParam $redirectURIParam $clientSecretParam $grantTypeACParam $authCodeParam

	# parse JSON
	$parsedJson = $jsonToken | ConvertFrom-Json

	If($parsedJson.error) {
		Write-Host "`n` -- Error" -foregroundcolor "red"
		Write-Host "`n$jsonToken`n"
	} Else {
		Write-Host "`n` -- Access Token OK" -foregroundcolor "green"
		Write-Host "`n$jsonToken`n"
	}

} Else {

	Write-Host "`n -- S2S Enabled -> Daemon Simulation (Client Certificate Mode seems enabled)`n" -foregroundcolor "Yellow"

	. '.\jwt-token-creation\O365ManagementAPI_getPK.ps1'

	$clientAssertion = "-d client_assertion=" + $encToken

	Write-Host "`n -- Retrieving AccessToken from Azure...`n" -foregroundcolor "Yellow"
	# Perform /token request towards common endpoint
	$jsonToken = & '.\bin\curl.exe' $requestPOST $tenantTokenRESTEndpoint $resourceParam $clientIDParam $grantTypeCCParam $clientAssertionTypeParam $clientAssertion

	# parse JSON
	$parsedJson = $jsonToken | ConvertFrom-Json

	If($parsedJson.error) {
		Write-Host "`n` -- Error" -foregroundcolor "red"
		Write-Host "`n$jsonToken`n"
	} Else {
		Write-Host "`n` -- Access Token OK" -foregroundcolor "green"
		Write-Host "`n$jsonToken`n"
	}

}

# extract Access Token
$access_token = $parsedJson.access_token

# define cURL path
$curl = '.\bin\curl.exe'
# setup Header
$header = "Authorization: Bearer " + $access_token

# setup test URL
$url = "https://manage.office.com/api/v1.0/" + $tid + "/activity/feed/subscriptions/list"

Write-Host " -- 1. Doing a first test REST call: Listing subscriptions`n`n" -foregroundcolor "Yellow"

$testToken = & $curl -H $header $url
$parsedTestToken = ConvertFrom-Json $testToken 

Write-Host "`n`Output" -foregroundcolor "Yellow"
Write-Host "--------`n"

($parsedTestToken | Format-List | Out-String).Trim()

Write-Host "`n"

$ExchangeUrl = "https://manage.office.com/api/v1.0/" + $tid + "/activity/feed/subscriptions/content?contentType=Audit.Exchange"
Write-Host " -- 2. Doing a second test REST call: Getting Exchange logs`n`n" -foregroundcolor "Yellow"

$testExchangeToken = & $curl -H $header $ExchangeUrl
$parsedTestExchangeToken = ConvertFrom-Json $testExchangeToken 

Write-Host "`n`Output" -foregroundcolor "Yellow"
Write-Host "--------`n"

($parsedTestExchangeToken | Format-List | Out-String).Trim()

Write-Host "`n"

# check if some results are returned, if yes inspect first result
If ($parsedTestExchangeToken.Count -gt 0) {

	Write-Host " -- 2.1 Doing an additional test REST call: Inspecting Exchange logs`n`n" -foregroundcolor "Yellow"

	# extracting contentUri
	$testExchangeItem = $parsedTestExchangeToken[0]
	$testExchangeItemUrl = $testExchangeItem.contentUri

	# do a GET cURL
	$testExchangeItemToken = & $curl -H $header $testExchangeItemUrl
	$parsedTestExchangeItemToken = ConvertFrom-Json $testExchangeItemToken 

	# create arrays to handle different types of activities
	$RegularExchangeActivities = @()
	$AdminExchangeActivities = @()
	$DCAdminExchangeActivities = @()

	# loop through activities
	ForEach ($activity in $parsedTestExchangeItemToken){

		# check current user type
		switch ($activity.UserType)
		{
			0 { $RegularExchangeActivities = $RegularExchangeActivities + $activity }
			2 { $AdminExchangeActivities = $AdminExchangeActivities + $activity }
			3 { $DCAdminExchangeActivities = $DCAdminExchangeActivities + $activity }
		}

	}

	Write-Host "`n`Output" -foregroundcolor "Yellow"
	Write-Host "--------`n"

	Write-Host "Regular Users`n" -foregroundcolor "DarkGreen"
	($RegularExchangeActivities | Format-List | Out-String).Trim()

	Write-Host "`nTenant Admins`n" -foregroundcolor "DarkGreen"
	($AdminExchangeActivities | Format-List | Out-String).Trim()

	Write-Host "`nMicrosoft Admins`n" -foregroundcolor "DarkGreen"
	($DCAdminExchangeActivities | Format-List | Out-String).Trim()

}

$AzureUrl = "https://manage.office.com/api/v1.0/" + $tid + "/activity/feed/subscriptions/content?contentType=Audit.AzureActiveDirectory"
Write-Host " -- 3. Doing a third test REST call: Getting Azure AD logs`n`n" -foregroundcolor "Yellow"

$testAzureToken = & $curl -H $header $AzureUrl
$parsedTestAzureToken = ConvertFrom-Json $testAzureToken 

Write-Host "`n`Output" -foregroundcolor "Yellow"
Write-Host "--------`n"

($parsedTestAzureToken | Format-List | Out-String).Trim()

Write-Host "`n"

# check if some results are returned, if yes inspect first result
If ($parsedTestAzureToken.Count -gt 0) {

	Write-Host " -- 3.1 Doing an additional test REST call: Inspecting Azure logs`n`n" -foregroundcolor "Yellow"

	# extracting contentUri
	$testAzureItem = $parsedTestAzureToken[0]
	$testAzureItemUrl = $testAzureItem.contentUri

	# do a GET cURL
	$testAzureItemToken = & $curl -H $header $testAzureItemUrl
	$parsedTestAzureItemToken = ConvertFrom-Json $testAzureItemToken 

	Write-Host "`n`Output" -foregroundcolor "Yellow"
	Write-Host "--------`n"

	($parsedTestAzureItemToken | Format-List | Out-String).Trim()

	Write-Host "`n"

}