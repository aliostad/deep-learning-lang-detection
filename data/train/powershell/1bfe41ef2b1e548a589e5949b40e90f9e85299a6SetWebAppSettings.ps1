
Set-ExecutionPolicy RemoteSigned

# Interactive login to your subscription
Add-AzureAccount

# List all subscriptions 
Get-AzureSubscription

$subscriptionName = "DYNSMSPAzureGPS-micham"



#set desired subscription to work with
Select-AzureSubscription -SubscriptionName $subscriptionName
#make sure we are in
Switch-AzureMode -Name AzureServiceManagement
# list all websites
Get-AzureWebsite

#specify the website names and app setting to distinguish them
$website1 = "cloudshop-we"
$settings1 = @{  "CloudShopName" = "West Europe"}

$website2 = "cloudshop-ne"
$settings2 = @{  "CloudShopName" = "North Europe"}


#set application settings:
Set-AzureWebsite $website1 -AppSettings $settings1 
Set-AzureWebsite $website2 -AppSettings $settings2


# shows websites in browser do they have different titles?
Show-AzureWebsite -Name $website1
Show-AzureWebsite -Name $website2


