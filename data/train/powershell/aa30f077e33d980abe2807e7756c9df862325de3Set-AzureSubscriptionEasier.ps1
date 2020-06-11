#Author: Nissan Dookeran
#Date: 11-Aug-2015
#Purpose: This script will set the current Azure subscription a little more easily for execution of subsequent commands
#Target user: Azure Administrators who have more than one Azure account, and then within each account have more than one subscription
# and need an easier way to switch quickly, or a script that can be passed on to junior administrators to have them
# execute desired tasks without messing up the first steps of choosing the correct subscription to manage correctly and 
# creating possible billing errors in future
 
$cacct=Read-Host 'Enter 1 to add an Azure account, or press Enter to continue with current account'
if ($cacct -eq 1)
{
  Add-AzureAccount
}
Write-Host 'Current Development environment is:'
Get-AzureSubscription -Current | Select SubscriptionName, SupportedModes, DefaultAccount | Format-Table

$csubscr=Read-Host 'Enter 1 to change, or press Enter to continue with current Subscription'
if ($csubscr -eq 1)
{
  Write-Host 'All available Azure Subscriptions are: '
  Get-AzureSubscription | Sort SubscriptionName | Select SubscriptionName, DefaultAccount | Format-Table
  #, DefaultAccount | Format-Table
  Write-Host '---------------------------------------------'
  $subscr= Read-Host 'What is the Azure Subscription Name to use' #"Infotech Demo and Development Environment"
  Select-AzureSubscription -SubscriptionName $subscr -Current
  Write-Host 'Current Development environment is now set to:'
  Get-AzureSubscription -Current | Select SubscriptionName, SupportedModes | Format-Table
}